Employee.create!(id_number: "300000", name:  "Fred", active: true)

Employee.create!(id_number: "300001", name:  "Bob", active: true)

Employee.create!(id_number: "300002", name:  "Steve", active: true)

Employee.create!(id_number: "300003", name:  "Nick", active: true)

Employee.create!(id_number: "300004", name: "Mitch", active: true)

Ticket.create!(number: "300000", name: "Smith. J", details_attributes:
          [{amount: "1", location: "1A", room: "1010", aasm_state: "ST", s_employee_id: "300000"},
           {amount: "2", location: "1B", room: "1010", aasm_state: "ST", s_employee_id: "300001"},
           {amount: "4", location: "1C", room: "1010", comment: "Fragile", aasm_state: "ST", s_employee_id: "300003"}])

Ticket.create!(number: "300001", name: "Nguyen. K", details_attributes:
          [{amount: "1", location: "1A", room: "1010", aasm_state: "ST", s_employee_id: "300001"},
           {amount: "7", location: "3C Wall", room: "1710", aasm_state: "ST", s_employee_id: "300002"}])

Ticket.create!(number: "300002", name: "O'Brien. T", active: false, details_attributes:
          [{amount: "1", location: "2B", room: "1515", aasm_state: "ST", s_employee_id: "300000",
            retrieved_employee_id: "2"}])

Ticket.create!(number: "300003", name: "Zhao. Y", details_attributes:
          [{amount: "4", location: "4C", room: "1010", aasm_state: "RNR", s_employee_id: "300003"},
           {amount: "3", location: "2A + 1 in fridge", room: "1810", aasm_state: "ST", s_employee_id: "300002"}])

Ticket.create!(number: "300005", name: "Jones. S", details_attributes:
          [{amount: "1", location: "3A", room: "1710", aasm_state: "ST", s_employee_id: "300004"},
           {amount: "1", location: "4A", room: "1210", aasm_state: "RNR", s_employee_id: "300004"}])

Ticket.create!(number: "300006", name: "Allen. L", details_attributes:
          [{amount: "3", location: "4C", room: "1515", aasm_state: "RNR", s_employee_id: "300002"},
           {amount: "3", location: "7C", room: "1010", aasm_state: "LT", s_employee_id: "300004"}])

Ticket.create!(number: "300007", name: "McDonald. R", details_attributes:
          [{amount: "2", location: "4B", room: "1515", aasm_state: "RNR", s_employee_id: "300002"}])

Employee.find(5).update_attribute(:active, false)


time_one = Time.now
100000.times do |d|
  if (rand(1..1000) > 999)
    Ticket.create!(number: d.to_s.rjust(6, "100000"), name: Faker::Name.name[0..24], details_attributes:
          [{amount: rand(1..10), location: (rand(1..7).to_s + ["A", "B", "C"].sample), room: ApplicationHelper::ROOMS.sample, aasm_state: "ST", s_employee_id: rand(300000..300003).to_s}])
  else
    Ticket.create!(number: d.to_s.rjust(6, "100000"), name: Faker::Name.name[0..24], active: false, details_attributes:
          [{amount: rand(1..10), location: (rand(1..7).to_s + ["A", "B", "C"].sample), room: ApplicationHelper::ROOMS.sample, aasm_state: "ST", s_employee_id: rand(300000..300003).to_s, retrieved_employee_id: ["1", "2", "3"].sample}])
  end
end
time_two = Time.now
total_time = time_two - time_one
puts total_time
