class Book < ApplicationRecord
  belongs_to :author

  validates :name, :pages, :author_id, presence: true
  validates :name, uniqueness: true
  validates :pages, numericality: { greater_than: 0 }

  def get_status
    return 0 unless self.readed_pages

    self.readed_pages / self.pages
  end
end
