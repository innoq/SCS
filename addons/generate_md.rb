require 'xml/xslt'

xslt = XML::XSLT.new()

outdir = File.join(File.dirname(__FILE__), "../markdown")
Dir.mkdir(outdir) unless File.directory?(outdir)

Dir.glob(File.join(File.dirname(__FILE__), "../*.html")).each do |input_file_name|
  xml = File.read(input_file_name)
  xml.gsub!(/^---$.*^---\n/m , "")
  xml = "<html><body>#{xml}</body></html>" if xml !~ /<html>/
  xslt.xml = xml

  xslt.xsl = File.join(File.dirname(__FILE__), "xhtml_to_md.xsl")

  if out = xslt.serve()
    out.gsub!(/<\?xml[^>]*>\n*/m, "")

    output_basename = File.basename(input_file_name, File.extname(input_file_name))
    output_file_name = File.join(outdir, "#{output_basename}.md")
    File.open(output_file_name, "w") do |f|
      f.puts out
    end  

    puts "Written #{out.count("\n")} lines of markdown to #{output_basename}.md"
  else
    puts "Could not extract any Markdown from #{input_file_name}"
  end
end