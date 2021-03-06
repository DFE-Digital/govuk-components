class GovukComponent::NotificationBanner < GovukComponent::Base
  attr_reader :title, :title_id, :success, :title_heading_level, :disable_auto_focus

  include ViewComponent::Slotable
  with_slot :heading, collection: true, class_name: 'Heading'
  wrap_slot(:heading)

  def initialize(title:, success: false, title_heading_level: 2, title_id: "govuk-notification-banner-title", disable_auto_focus: nil, classes: [], html_attributes: {})
    super(classes: classes, html_attributes: html_attributes)

    @title               = title
    @title_id            = title_id
    @success             = success
    @title_heading_level = title_heading_level
    @disable_auto_focus  = disable_auto_focus
  end

  def success_class
    %(govuk-notification-banner--success) if success?
  end

  def success?
    @success
  end

  def render?
    headings.any? || content.present?
  end

  def title_tag
    fail "title_heading_level must be a number between 1 and 6" unless title_heading_level.is_a?(Integer) && title_heading_level.in?(1..6)

    "h#{title_heading_level}"
  end

  class Heading < ViewComponent::Slot
    attr_accessor :text, :link_target, :link_text

    def initialize(text: nil, link_text: nil, link_target: nil)
      @text        = text
      @link_text   = link_text
      @link_target = link_target
    end

    def default_classes
      %w(govuk-notification-banner__heading)
    end
  end

private

  def default_classes
    %w(govuk-notification-banner)
  end

  def data_params
    { "module" => "govuk-notification-banner", "disable-auto-focus" => disable_auto_focus }.compact
  end
end
