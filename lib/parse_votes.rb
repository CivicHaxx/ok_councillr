RawVoteRecord.all.each do |item|
	raw_num = item.agenda_item
	item_number = raw_num.split(".").delete_at(0).join(".")
end
