#!/usr/bin/ruby
require "#{File.dirname($0)}/term-ansicolor-0.0.4/lib/term/ansicolor.rb"
require "#{File.dirname($0)}/../lib/smart"
include Term::ANSIColor

def rememberPath(path,output)
  @remember.include?(path) ? red + output + clear : output
end

def prnAttrs(node)
  str = node.attributes.collect{ |a| rememberPath(a.path,a.qname + '="' + a.to_s + '"') }.join(" ")
  str == "" ? "" :  " " + str
end

def prnTree(node,depth,mixed)
  print " " * depth unless mixed
  print "<" + rememberPath(node.path,node.qname.to_s) + prnAttrs(node) + ">"

  print "\n" if node.element_only? && !mixed
  node.children.each { |n|
    case n
      when XML::Smart::Dom::Element; prnTree(n,depth+2,node.mixed? | mixed)
      when XML::Smart::Dom::Text; print rememberPath(n.path,n.text)
    end  
  }
  print " " * depth if node.element_only? && !mixed
  print "</" + rememberPath(node.path,node.qname.to_s) + ">" 
  print "\n" unless mixed
end

doc = XML::Smart.open(File.dirname($0) + "/EXAMPLE.xml")

# xpath expression that should be visualised
xpath = ARGV[0] || "/"

# remember pathes, that an xpath expression selects
@remember = []
message = ''
begin
  tmp = doc.find(xpath)
  if tmp === XML::Smart::Dom::NodeSet
    @remember = doc.find(xpath).collect { |n| n.path }
  else
    message = tmp
  end  
rescue
  puts "Invalid XPath!"
end

# pretty print tree
puts bold + "Result:" + clear + " " + message.inspect + "\n"
puts bold + "XPath :" + clear + " " + xpath + "\n"
prnTree(doc.root,0,false)
