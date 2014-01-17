require "markdevn"

describe Markdevn, "#from_md" do
  it "converts one line of text" do
    Markdevn.from_md("Test note here!").should ==
      Markdevn.wrap("<p>Test note here!</p>")
  end

  it "converts paragraphs" do
    Markdevn.from_md("Line 1\n\nLine 2").should ==
      Markdevn.wrap("<p>Line 1</p>\n\n<p>Line 2</p>")
  end

  it "collapses single CRs" do
    Markdevn.from_md("Line 1\nLine 1 still").should ==
      Markdevn.wrap("<p>Line 1\nLine 1 still</p>")
  end

  it "converts bold" do
    Markdevn.from_md("**Bold text!**").should ==
      Markdevn.wrap("<p><strong>Bold text!</strong></p>")
  end
end
