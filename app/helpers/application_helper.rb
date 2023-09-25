module ApplicationHelper

  def asset_exist?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end

  def index_table_for(collection, options = { actions: %w(show edit destroy) }, &block)
    options[:class] = "table table-hover"
    inner_table = if collection.count > 0
                    content_tag(:div, class: "table-responsive") do
                      t = EasyTable::TableBuilder.new(collection, self, options)
                      block.yield(t) if block_given?
                      actions = options.delete(:actions)
                      if actions
                        t.column "Ações", class: "text-right", header_class: "text-right" do |i|
                          actions_links(actions, i)
                        end
                      end
                      t.build
                    end
                  else
                    content_tag :div, class: "text-center pb-3 pt-3" do
                      content_tag :p, "Nenhum resultado", class: "mb-0"
                    end
                  end
    if options[:wrapper] == false
      content = inner_table
    else
      content = content_tag :div, class: "card-default card" do
        content_tag :div, class: "card-body" do
          inner_table
        end
      end
    end

    #content + collection.blank? ? nil : paginate(collection)
    content +  paginate(collection)
  end

  def index_search_form_for(q, options = {}, method_options = { submit: true }, &block)
    search_form_for q, options do |f|
      content_tag :div, class: "card-default card" do
        content_tag :div, class: "card-body" do
          content = capture(f, &block)
          if method_options[:submit]
            content += content_tag :hr, nil, class: "d-print-none"
            content += content_tag :div, class: "clearfix" do
              f.button :submit, t("action.search"), class: "btn btn-success float-right"
            end
          end
          content.html_safe
        end
      end
    end
  end

  def index_search_form(q, options = {}, method_options = { submit: true }, &block)
    search_form_for q, options do |f|
      content_tag :div do
        content_tag :div do
          content = capture(f, &block)
          if method_options[:submit]
            content += content_tag :hr, nil, class: "d-print-none"
            content += content_tag :div, class: "clearfix" do
              f.button :submit, t("action.search"), class: "btn btn-success float-right"
            end
          end
          content.html_safe
        end
      end
    end
  end

  def partial_simple_form_for(item, options = {}, &block)
    to_submit = options[:submit].nil? ? true : options.delete(:submit)
    options.deep_merge!(html: { 'data-parsley-validate': "" }) unless options[:disable_validation]
    options.deep_merge!(defaults: { disabled: true }) if action_name == "show"

    # # Avoid STI urls
    # options[:url] ||= if options.key?(:format)
    #                     polymorphic_path(record, format: options.delete(:format))
    #                   else
    #                     polymorphic_path(item.class.base_class, {})
    #                   end

    total = basic_error_messages(item) || ""
    total += simple_form_for(item, options) do |f|
      content = capture(f, &block)
      #if to_submit
      # content += button_footer(f)
      #end
      content.html_safe
    end
    total.html_safe
  end

  def button_footer(f, options = {})
    label = options[:label]
    content = content_tag :hr, nil, class: "d-print-none"
    raw(content + content_tag(:div, class: "clearfix", id: "item_submit") do
      if action_name == "show"
        link_to t("action.edit"), { action: "edit" }, class: "btn btn-success float-right"
      else
        if label.present?
          f.button :submit, label, class: "btn btn-success float-right"
        else
          f.button :submit, 'Fazer Upload',class: "btn btn-success float-right"
        end
      end
    end)
  end

  def actions_links(l, i)
    content_tag :div, class: "btn-group" do
      l.map do |ll|
        case ll
        when "show"
          link_to t("action.show"), { action: "show", id: i.id }, class: "btn  btn-sm", style: "border-radius: 18px; height: 21px;"
        when "download"
          link_to t("action.download"), { action: "show", format: "pdf", id: i.id }, target: "_blank", class: "btn btn-secondary btn-sm"
        when "edit"
          link_to t("action.edit"), { action: "edit", id: i.id }, class: "btn  btn-sm", style: "border-radius: 14px; height: 24px;"
        when "details"
          link_to t("action.details"), { action: "edit", id: i.id }, class: "btn  lime btn-sm"
        when "destroy"
          link_to t("action.destroy"), { action: "destroy", id: i.id, :method => "delete"  }, method: :delete, data: { confirm: "Você tem certeza?" }, class: "btn red btn-sm", style: "border-radius: 14px; height: 24px;"
        when "block"
          if i.locked_at.present?
            link_to t("action.unblock"), { action: "unblock", id: i.id }, method: :patch, data: { confirm: "Você tem certeza?" }, class: "btn btn-success btn-sm"
          else
            link_to t("action.block"), { action: "block", id: i.id }, method: :patch, data: { confirm: "Você tem certeza?" }, class: "btn btn-danger btn-sm"
          end
        end
      end.join.html_safe
    end
  end
  def link_to_back(name = nil, html_options = nil, &block)
    session_url = session["#{params[:controller]}_results".to_sym]
    session_url.present? ? session_url : :back
    link_to(name, session_url, html_options, &block)
  end
  def basic_error_messages(item = @item)
    return if item.try(:errors).nil? || item.errors.empty?

    messages = ''
    item.errors.full_messages.each do |msg|
      messages += build_notification(msg)
    end

    messages.html_safe
  end
  def build_notification(msg, type = 'danger')
    content_tag :div, class: "alert alert-#{type} alert-dismissible fade show", role: 'alert' do
      content = button_tag class: 'close', 'data-dismiss': 'alert', 'aria-label': 'Close' do
        content_tag :span, '×', 'aria-hidden': 'true'
      end
      content + msg
    end
  end
  def notification_flash
    content_tag :script do
      content = ''
      flash.each do |key, value|
        key = bootstrap_alert(key)
        if value.is_a? Array
          value = "'#{value[1]}', '#{value[0]}'"
        else
          value = "'#{value}', '#{t("flash.actions.#{key}")}'"
        end
        content += "toastr['#{key}'](#{value});"
      end
      content.html_safe
    end.html_safe
  end
  def notification_errors
    content_tag :script do
      content = ''
      @item.errors.messages.each do |key, msg|
        next if msg.blank?
        content += "toastr['error']('#{t("simple_form.labels.#{@item.model_name.param_key}.#{key}")} #{msg.first}', 'Ooops!');"
      end
      content.html_safe
    end.html_safe
  end
  def action_name_label
    case action_name
    when 'create'
      'new'
    when 'update'
      'edit'
    else
      action_name
    end
  end
  def breadcrumb(new = false)
    plural = %w(index).include?(action_name_label) ? 'other' : 'one'
    title = t("controllers.#{controller_name}.#{plural}", default: "action.#{action_name_label}")
    action = t("views.#{controller_name}.action.#{action_name_label}", default: t("action.#{action_name_label}"))
    # title "#{title} | #{action}"

    content_tag :div, class: 'content-heading' do
      left = content_tag :div do
        div = content_tag(:ol, class: 'breadcrumb breadcrumb px-0 pb-0') do
          content = content_tag :li, class: 'breadcrumb-item' do
            link_to 'Página Inicial', root_path
          end
          content += content_tag :li, class: 'breadcrumb-item' do
            link_to title, { controller: "#{controller_name}", action: 'index' }
          end
          content + content_tag(:li, class: 'breadcrumb-item active') do
            action
          end
        end
        raw(title + div)
      end
      if new
        left += content_tag(:div, class: 'ml-auto') do
          content_tag :div, class: 'btn-group' do
            link_to 'Novo', { action: 'new' }, class: 'btn btn-secondary'
          end
        end
      end
      left
    end.html_safe
  end
end
