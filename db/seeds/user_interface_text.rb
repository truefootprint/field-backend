key_values = {
  en: {
    "login.prompt"         => "What’s your mobile number?",
    "login.failed"         => "Login failed. Unrecognised mobile number.",
    "login.placeholder"    => "e.g. 0123456789",
    "n_of_m"               => "%{n} of %{m}",
    "intro.next_page"      => "Next page",
    "intro.finish"         => "Continue to project",
    "intro.page_1"         => "...",
    "intro.page_2"         => "...",
    "intro.page_3"         => "...",
    "intro.page_4"         => "...",
    "intro.page_5"         => "...",
    "intro.page_6"         => "...",
    "intro.page_7"         => "...",
    "intro.page_8"         => "...",
    "intro.page_9"         => "...",
    "summary.title"        => "Project summary",
    "summary.body"         => "...",
    "summary.contract"     => "Project contract",
    "view_details"         => "View details",
    "add_notes"            => "Add your notes...",
    "photo.take"           => "Take photo",
    "photo.choose"         => "Choose from library",
    "photo.remove"         => "Remove photo",
    "issue.record"         => "Record an issue",
    "issue.recorded"       => "Issue recorded",
    "issue.is_it_resolved" => "Is this issue resolved?",
    "issue.are_you_sure"   => "Are you sure this issue is resolved?",
    "issue.yes_resolved"   => "Yes, it’s resolved",
    "issue.resolved"       => "Issue resolved",
    "yes"                  => "Yes",
    "no"                   => "No",
    "submit"               => "Submit",
    "cancel"               => "Cancel",
    "loading"              => "Loading...",
    "version"              => "FieldApp version %{n}",
    "try_again"            => "Try again",
    "no_wifi"              => "Please connect to WiFi and try again.",
    "download_failed"      => "Download failed",
    "error.network.title"  => "Network error",
    "error.network.body"   => "Sorry, there seems to be a problem with our computers. Please try again later.",
    "error.unknown.title"  => "Unexpected error",
    "error.unknown.body"   => "Sorry, there seems to be a problem. If it keeps happening, try reinstalling the app.",
    "error.details"        => "Error details:",
  },
  fr: {
    "login.prompt"         => "Quel est ton numéro de portable?",
    "login.failed"         => "Échec de la connexion. Numéro de mobile non reconnu.",
    "login.placeholder"    => "par ex. 0123456789",
    "n_of_m"               => "%{n} sur %{m}",
    "intro.next_page"      => "Page suivante",
    "intro.finish"         => "Continuez à projeter",
    "intro.page_1"         => "...",
    "intro.page_2"         => "...",
    "intro.page_3"         => "...",
    "intro.page_4"         => "...",
    "intro.page_5"         => "...",
    "intro.page_6"         => "...",
    "intro.page_7"         => "...",
    "intro.page_8"         => "...",
    "intro.page_9"         => "...",
    "summary.title"        => "Résumé du projet",
    "summary.body"         => "...",
    "summary.contract"     => "Contrat de projet",
    "view_details"         => "Voir les détails",
    "add_notes"            => "Ajoutez vos notes...",
    "photo.take"           => "Prendre une photo",
    "photo.choose"         => "Choisissez une photo",
    "photo.remove"         => "Retirer photo",
    "issue.record"         => "Enregistrer un problème",
    "issue.recorded"       => "Problème enregistré",
    "issue.is_it_resolved" => "Ce problème est-il résolu?",
    "issue.are_you_sure"   => "Êtes-vous sûr que ce problème est résolu?",
    "issue.yes_resolved"   => "Oui, c'est résolu",
    "issue.resolved"       => "Problème résolu",
    "yes"                  => "Oui",
    "no"                   => "Non",
    "submit"               => "Soumettre",
    "cancel"               => "Annuler",
    "loading"              => "Chargement...",
    "version"              => "FieldApp version %{n}",
    "try_again"            => "Réessayer",
    "no_wifi"              => "Veuillez vous connecter au WiFi et réessayer.",
    "download_failed"      => "Échec du téléchargement",
    "error.network.title"  => "Erreur réseau",
    "error.network.body"   => "Désolé, il semble y avoir un problème avec nos ordinateurs. Veuillez réessayer plus tard.",
    "error.unknown.title"  => "Erreur inattendue",
    "error.unknown.body"   => "Désolé, il semble y avoir un problème. Si cela continue, essayez de réinstaller l'application.",
    "error.details"        => "Détails de l'erreur:",
  },
}

pre_login_keys = %w[
  loading
  login.prompt
  login.failed
  login.placeholder
  error.network.title
  error.network.body
  error.unknown.title
  error.unknown.body
  error.details
]

key_values.each do |locale, translations|
  I18n.with_locale(locale) do
    translations.each do |key, value|
      record = UserInterfaceText.find_or_initialize_by(key: key)
      record.update!(value: value, pre_login: pre_login_keys.include?(key))
    end
  end
end
