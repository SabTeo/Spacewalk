class Article < ActiveRecord::Base
    has_many :comments 

    def self.get_supported_languages()
        {   'Italiano' => 'IT',
            'English' => 'EN',
            'Deutsch' => 'DE',
            'Español' => 'ES',
            'Français' => 'FR',
            '日本語' => 'JA',
            'Русский язык' => 'RU',
            '简体字' => 'ZH'
        }
    end

end