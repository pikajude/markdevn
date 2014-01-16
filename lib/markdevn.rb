require "markdevn/version"
require "nokogiri"
require "ruby-debug"

module Markdevn
  class << self
    def to_md(doc)
      @doc = Nokogiri::XML(doc)
      to_md_single(@doc.css("en-note"))
    end

    def sanitize(node, opts = { :keep => [] })
      node.attributes.each{|k,_|node.remove_attribute(k) unless opts[:keep].include?(k)}
    end

    def to_md_single(fragment, list_type = :ul, list_depth = -1)
      def preserve(node)
        node.inner_html = to_md_single(node.children)
        node.to_html
      end

      list_index = 1

      fragment.map.with_index do |node, i|
        case node.name
        when "en-note", "div"
          to_md_single(node.children) + "\n\n"
        when "ol"
          to_md_single(node.children, :ol, list_depth + 1) + "\n\n"
        when "ul"
          to_md_single(node.children, :ul, list_depth + 1) + "\n\n"
        when "li"
          spaces = list_index == 1 ? "" : " " * (list_depth * 2)
          prefix = list_type == :ul ? "* " : "#{list_index}. "
          list_index += 1
          spaces + prefix + to_md_single(node.children, list_type, list_depth) + "\n"
        when "span"
          if node.attr("style").nil?
            to_md_single(node.children)
          else
            preserve(node)
          end
        when "br"
          ""
        when "en-todo"
          if node.attr("checked") == "true"
            "[x]"
          else
            "[ ]"
          end
        when "sup", "sub"
          preserve(node)
        when "strong"
          "**" + to_md_single(node.children) + "**"
        when "em"
          "*" + to_md_single(node.children) + "*"
        when "hr"
          "\n\n***\n\n"
        when "a"
          "[#{to_md_single(node.children)}](#{node.attr("href")})"
        when "table"
          sanitize(node, keep: %w[border cellpadding cellspacing])
          preserve(node)
        when "tr"
          sanitize(node)
          preserve(node)
        when "td"
          sanitize(node)
          preserve(node)
        when "text"
          if node.text =~ /\A\s*\Z/
            ""
          else
            node.text
          end
        else
          raise "Not handled: #{node.inspect}"
        end
      end.join("").strip.gsub("\n\n\n\n", "\n\n")
    end
  end
end
