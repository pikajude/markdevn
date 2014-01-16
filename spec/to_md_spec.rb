require "markdevn"
require "test_helper"

def convert(s)
  Markdevn.to_md(wrap(s))
end

describe Markdevn, "#to_md" do
  it "converts one line of text" do
    convert("<div>Test note here!</div>").should == "Test note here!"
  end

  it "converts paragraphs" do
    convert(%Q{
      <div>Test note here!</div>
      <div>Second line!</div>
    }).should == "Test note here!\n\nSecond line!"
  end

  it "converts bold" do
    convert(%Q{
      <div><span><strong>Bold text!</strong></span></div>
    }).should == "**Bold text!**"
  end

  it "converts italic" do
    convert(%Q{
      <div><span><em>Italic text!</em></span></div>
    }).should == "*Italic text!*"
  end

  it "preserves non-defined styles" do
    convert(%Q{
      <div><span style="text-decoration: underline">Underlined!</span></div>
    }).should == %Q{<span style="text-decoration: underline">Underlined!</span>}
  end

  it "preserves superscript" do
    convert("<sup>Superscript!</sup>").should == "<sup>Superscript!</sup>"
  end

  it "preserves subscript" do
    convert("<sub>Subscript!</sub>").should == "<sub>Subscript!</sub>"
  end

  it "renders lists" do
    convert(%Q{
      <ul>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
      </ul>
    }).should == %Q{
      * Item 1
      * Item 2
      * Item 3
    }.strip.gsub(/^      /, "")
  end

  it "renders ordered lists" do
    convert(%Q{
      <ol>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
      </ol>
    }).should == %Q{
      1. Item 1
      2. Item 2
      3. Item 3
    }.strip.gsub(/^      /, "")
  end

  it "renders nested lists" do
    convert(%Q{
      <ul>
        <li>Item</li>
        <li>
          <ol>
            <li>Nested item</li>
            <li><span>Nested item 2</span></li>
            <li>
              <ul>
                <li>Doubly nested item</li>
              </ul>
            </li>
            <li>Nested item 3</li>
          </ol>
        </li>
        <li>Item 3</li>
      </ul>
    }).should == %Q{
      * Item
      * 1. Nested item
        2. Nested item 2
        3. * Doubly nested item
        4. Nested item 3
      * Item 3
    }.strip.gsub(/^      /, "")
  end

  it "converts horizontal rules" do
    convert("<ul><li>thing</li></ul><div><hr/></div><div>baz</div>").should == %Q{
      * thing

      ***

      baz
    }.strip.gsub(/^      /, "")
  end

  it "removes empty divs" do
    convert("<div></div>").should == ""
    convert("<div><br clear=\"none\"></div>").should == ""
  end

  it "converts links" do
    convert("<a shape=\"rect\" href=\"http://google.com\">Link to a thing</a>").should == "[Link to a thing](http://google.com)"
  end

  it "converts todos to checkboxes" do
    convert("<en-todo></en-todo>").should ==
      "[ ]"
  end

  it "converts checked todos to checked checkboxes" do
    convert("<en-todo checked=\"true\"></en-todo>").should ==
      "[x]"
  end

  it "preserves tables" do
    convert(%Q{
      <table width="100%" border="1" cellspacing="0" cellpadding="2">
        <tr>
          <td colspan="1" rowspan="1" valign="top">
            item 1
          </td>
          <td colspan="1" rowspan="1" valign="top">
            item 2
          </td>
        </tr>
        <tr>
          <td colspan="1" rowspan="1" valign="top">
            item 3
          </td>
          <td colspan="1" rowspan="1" valign="top">
            item 4
          </td>
        </tr>
      </table>
    }).should == %Q{
      <table border="1" cellspacing="0" cellpadding="2">
      <tr>
      <td>item 1</td>
      <td>item 2</td>
      </tr>
      <tr>
      <td>item 3</td>
      <td>item 4</td>
      </tr>
      </table>
    }.strip.gsub(/^      /, "")
  end
end
