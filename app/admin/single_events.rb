ActiveAdmin.register SingleEvent do
  config.sort_order = "occurrence_asc"
  menu false
  controller do
    nested_belongs_to :event
  end

  index do
    column :id
    column :name do |single_event|
      single_event.name || single_event.event.name
    end
    column :category
    column :description do |single_event|
      single_event.description.try :truncate, 80
    end
    column :occurrence
    column :url do |single_event|
      a "Link", href: single_event.url
    end
    column :twitter do |single_event|
      a "@#{single_event.twitter}", href: "http://twitter.com/#{single_event.twitter}" unless single_event.twitter.blank?
    end
    column :twitter_hashtag do |single_event|
      a "##{single_event.twitter_hashtag}", href: "http://twitter.com/search/%23#{single_event.twitter_hashtag}" unless single_event.twitter_hashtag.blank?
    end
    default_actions
  end

  show do |ad|
    attributes_table do
      row :id
      row :event
      row :name
      row :occurrence
      row :duration
      row :full_day
      row :description do |p|
        convert_markdown p.description
      end
      row :region
      row :venue
      row :venue_info
      row :twitter
      row :twitter_hashtag
      row :url
      row :picture
      row :tags do |p|
        p.tags.join(", ")

      end
    end
  end

  form do
    render partial: 'form'
  end

  controller do
    def permitted_params
      params.permit(single_event: [
        :event,
        :name,
        :occurrence,
        :duration,
        :full_day,
        :description,
        :region,
        :venue,
        :venue_info,
        :twitter,
        :twitter_hashtag,
        :url,
        :picture,
        :tags,
        :region_id,
        :venue_id,
        :use_venue_info_of_event,
        :category_id,
        :picture_id,
        :tag_list
      ])
    end
  end
end
