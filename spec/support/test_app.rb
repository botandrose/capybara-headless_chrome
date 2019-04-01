class TestApp < Struct.new(:app)
  def call hash
    case hash["PATH_INFO"]
    when "/" then [200, { "Content-Type" => "text/html" }, ["<a href='/document.pdf'>Download document.pdf</a>"]]
    when "/document.pdf" then  [200, { "Content-Type" => "application/pdf" }, [File.read("spec/support/document.pdf")]]
    else [400, {}, ["Not found"]]
    end
  end
end

