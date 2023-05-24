ActiveAdmin.register Blog do
  permit_params :category, :title, :status, :slug, :read_time, :video_link

  index do
    selectable_column
    id_column
    column :title
    column :status
    column :published_at
    column('Likes Count') { |blog| blog.likes.count }
    column('Comments Count') { |blog| blog.comments.count }
    column :user
    column :category
    actions
  end

  scope 'All Blogs', :all
  scope 'Todays Blogs', :created_today
  scope 'Published Blogs', :published
  scope 'Scheduled Blogs', :scheduled
  scope 'Draft Blogs', :draft

  filter :user
  filter :category
  filter :title
  filter :status, filters: [:equals]
  filter :slug
  filter :published_at
  filter :read_time
  filter :created_at

  form do |f|
    f.inputs do
      f.input :category
      f.input :title
      f.input :status
      f.input :slug
      f.input :read_time
      f.input :video_link
    end
    f.actions
  end

  show do
    attributes_table do
      row('id') { |blog| link_to 'Show on web', blog_path(blog) }
      row :title
      row :video_link
      row :summary
      row :status
      row :slug
      row :published_at
      row :read_time
      row :user
      row :category
      row('comments_count') { |blog| blog.comments.count }
      row('likes_count') { |blog| blog.likes.count }
      row :created_at
      row :updated_at
    end

    panel 'Blog Comments' do
      table_for blog.comments do
        column :id
        column :user
        column :content
        column 'Parent Comment' do |comment|
          link_to comment.parent.id, admin_user_comment_path(comment.parent) if comment.parent.present?
        end
        column('Likes Count') { |comment| comment.likes.count }
        column :created_at
      end
    end

    panel 'Blog Likes' do
      table_for blog.likes do
        column :id
        column :user
        column :created_at
      end
    end
  end
end
