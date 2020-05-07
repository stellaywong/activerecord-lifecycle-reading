class Post < ActiveRecord::Base

  belongs_to :author
  validate :is_title_case 

  # before_validation is called BEFORE validation
  before_validation :make_title_case

  # before_save is called AFTER validation, so X not title_case --> rollback.
  # before_save :make_title_case  # doesn't work.
  before_save :im_saving

  before_create :say_hi
  # before_create is called when the object is new --> created the first time. similar to before_save.

  # rule of thumb: 
  # 1. Whenever you are modifying an attribute of the model, use before_validation. 
  # 2. If you are doing some other action, then use before_save.

  private

  # look at the server logs for why create doesn't go through :)
  # when create works, there's a SQL command for INSERT that looks like this: 
  # INSERT INTO "posts" ("title", "description", "created_at", "updated_at") VALUES (?, ?, ?, ?) [["title", "Hello"], ["description", "World!"], ["created_at", "2020-05-07 20:26:52.506169"], ["updated_at", "2020-05-07 20:26:52.506169"]]

  # when edit works, there's a SQL command for UPDATE that looks like this: 
  # UPDATE "posts" SET "title" = ?, "updated_at" = ? WHERE "posts"."id" = ?  [["title", "Hello1"], ["updated_at", "2020-05-07 20:30:34.956700"], ["id", 1]]
  def is_title_case
    if title.split.any?{|w|w[0].upcase != w[0]}
      errors.add(:title, "Title must be in title case")
    end
  end

  def make_title_case
    self.title = self.title.titlecase
    p "before_validation"
  end

  def im_saving
    p "before_save"
  end

  def say_hi
    p "before_create"
    # open rails server in the terminal
    # then open localhost:3000 <-- 3000 is the port number
    # it'll appear in the server logs the first time new --> save
  end
end
