key_values = {
  :"en-GB" => {
    "n_of_m"               => "%{n} of %{m}",
    "project_contract"     => "Project contract",
    "n_activities"         => "This project has %{n} activities to monitor",
    "view_details"         => "View details",
    "add_notes"            => "Add your notes...",
    "photo.take"           => "Take photo",
    "photo.choose"         => "Choose from library",
    "issue.record"         => "Record an issue",
    "issue.is_it_resolved" => "Is this issue resolved?",
    "issue.are_you_sure"   => "Are you sure this issue is resolved?",
    "issue.yes_resolved"   => "Yes, it’s resolved",
    "issue.resolved"       => "Issue resolved",
    "yes"                  => "Yes",
    "no"                   => "No",
    "submit"               => "Submit",
    "cancel"               => "Cancel",
  },
  :"sw-KE" => {
    "n_of_m"               => "%{n} ya %{m}",
    "project_contract"     => "Mkataba wa mradi",
    "n_activities"         => "Mradi huu una shughuli %{n} za kufuatilia",
    "view_details"         => "Angalia maelezo",
    "add_notes"            => "Ongeza maelezo yako...",
    "photo.take"           => "Piga picha",
    "photo.choose"         => "Chagua kutoka maktaba",
    "issue.record"         => "Rekodi suala",
    "issue.is_it_resolved" => "Je! Suala hili limatatuliwa?",
    "issue.are_you_sure"   => "Je! Una uhakika suala hili limetatuliwa?",
    "issue.yes_resolved"   => "Ndio, imeamuliwa",
    "issue.resolved"       => "Suala litatatuliwa",
    "yes"                  => "Ndio",
    "no"                   => "Hapana",
    "submit"               => "Peana",
    "cancel"               => "Ghairi",
  },
}

key_values.each do |locale, translations|
  I18n.with_locale(locale) do
    translations.each do |key, value|
      record = UserInterfaceText.find_or_initialize_by(key: key)
      record.update!(value: value)
    end
  end
end
