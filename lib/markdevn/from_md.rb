require 'redcarpet'

module Markdevn
  class << self
    def wrap(str)
%Q{<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>#{str}</en-note>}
    end

    def from_md(str)
      wrap(Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(str).strip)
    end
  end
end
