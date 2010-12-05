require "jsduck/doc_links"

describe JsDuck::DocLinks, "#parse" do

  before do
    @links = JsDuck::DocLinks.new("Context")
  end

  it "replaces {@link Ext.Msg} with link to class" do
    @links.replace("Look at {@link Ext.Msg}").should ==
      'Look at <a href="output/Ext.Msg.html" ext:cls="Ext.Msg">Ext.Msg</a>'
  end

  it "replaces {@link Foo#bar} with link to class member" do
    @links.replace("Look at {@link Foo#bar}").should ==
      'Look at <a href="output/Foo.html#Foo-bar" ext:cls="Foo" ext:member="bar">Foo.bar</a>'
  end

  it "uses context to replace {@link #bar} with link to class member" do
    @links.replace("Look at {@link #bar}").should ==
      'Look at <a href="output/Context.html#Context-bar" ext:cls="Context" ext:member="bar">bar</a>'
  end

  it "allows use of custom link text" do
    @links.replace("Look at {@link Foo link text}").should ==
      'Look at <a href="output/Foo.html" ext:cls="Foo">link text</a>'
  end

  it "leaves text without {@link...} untouched" do
    @links.replace("Look at {@me here} too").should ==
      'Look at {@me here} too'
  end

  it "ignores unfinished {@link tag" do
    @links.replace("unfinished {@link tag here").should ==
      'unfinished {@link tag here'
  end
end