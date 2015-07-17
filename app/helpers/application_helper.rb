module ApplicationHelper
  def auth_token
    html = <<-HTML
    <input type="hidden"
      name="authenticity_token"
      value="#{form_authenticity_token}">
    HTML

    html.html_safe
  end

  def show_errors
    html = "<ul>"
    if flash[:errors]
      flash[:errors].each do |error|
        html += "<li>  #{error} </li>"
      end
    end
    html += "</ul>"

    html.html_safe
  end
end
