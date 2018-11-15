module Features
  def create_item(item)
    fill_in 'Name', with: item.name
    fill_in 'Description', with: item.description
    fill_in 'Size', with: item.size
    fill_in 'Note', with: item.note
  end

  def item_page_content(item)
    expect(page).to have_content item.name
    expect(page).to have_content item.description
    expect(page).to have_content item.size
    expect(page).to have_content item.note
  end

  def edit_item(item)
    fill_in 'Name', with: item.name + '!!'
    fill_in 'Description', with: item.description + '!!'
    fill_in 'Size', with: item.size + '!!'
    fill_in 'Note', with: item.note + '!!'
  end
end
