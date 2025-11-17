unless WebConfig.current
  WebConfig.create!(key: 'default')
end

unless Theme.current
  Theme.create!(
    name: 'default',
    is_default: true,
    source: 'local',
    path: ENV.fetch('WEB')
  )
end

settings = {
  "groups": [
    {
      "name": "General",
      "sections": [
        {
          "name": "",
          "configs": [
            {
              "key": "website.name",
              "name": "Name",
              "data_type": "string"
            },
            [
              {
                "key": "logo_url",
                "name": "Logo",
                "data_type": "image"
              },
              {
                "key": "favicon_url",
                "name": "Favicon",
                "data_type": "image"
              }
            ]
          ]
        },
        {
          "name": "",
          "configs": [
            [
              {
                "key": "email",
                "name": "Email info"
              },
              {
                "key": "phone",
                "name": "Hotline"
              },
              {
                "key": "phone_text",
                "name": "Hotline Text"
              }
            ],
            [
              {
                "key": "office_address",
                "name": "Office Address"
              },
              {
                "key": "vpdd",
                "name": "Vpdd address"
              },
              {
                "key": "worktime",
                "name": "Vpdd address"
              }
            ],
            [
              {
                "key": "social.zalo_link",
                "name": "Link zalo"
              },
              {
                "key": "social.messenger_link",
                "name": "Link messenger"
              }
            ],
            [
              {
                "key": "social.facebook_link",
                "name": "Link Facebook"
              },
              {
                "key": "social.youtube_link",
                "name": "Link Youtube"
              }
            ],
            {
              "key": "map",
              "name": "Iframe map",
              "data_type": "text"
            }
          ]
        },
        {
          "name": "",
          "configs": [
            {
              "key": "gtm.code",
              "name": "Google Tag Manager Code"
            }
          ]
        }
      ]
    },
    {
      "name": "Notifications",
      "sections": [
        {
          "name": "Email notifications",
          "configs": [
            [
              {
                "key": "notifications.email.enabled",
                "name": "Enable sending email",
                "data_type": "boolean"
              },
              {
                "key": "notifications.emails.default_list",
                "name": "Default emails"
              }
            ],
            [
              {
                "key": "notifications.contact_received.enabled",
                "name": "Send when contact_received",
                "data_type": "boolean"
              },
              {
                "key": "notifications.contact_received.emails",
                "name": "Contact received emails"
              }
            ],
            [
              {
                "key": "notifications.order_received.enabled",
                "name": "Send when order received",
                "data_type": "boolean"
              },
              {
                "key": "notifications.order_received.emails",
                "name": "Order received emails"
              }
            ]
          ]
        }
      ]
    },
    {
      "name": "SEO",
      "sections": [
        {
          name: "Indexing",
          "configs": [
            {
              "key": "seo.index_all",
              "name": "Index all pages",
              "data_type": "boolean"
            }
          ]
        },
        {
          name: "Tracking",
          "configs": [
            [
              {
                "key": "gtm.script.head",
                "name": "Google Tag Manager Script (head)",
                "data_type": "text"
              },
              {
                "key": "gtm.script.body",
                "name": "Google Tag Manager Script (body)",
                "data_type": "text"
              }
            ],
            [
              {
                "key": "gtag.script",
                "name": "Google Tag Script (GA4)",
                "data_type": "text"
              },
            ]
          ]
        }
      ]
    },
    {
      "name": "Admin",
      "configs": [
        {
          "key": "admin.contacts_list.display_fields",
          "name": "Contact list fields",
          "data_type": "string"
        }
      ]
    }
  ]
}

WebConfig.current.add_json('website.settings', settings)

advanced_settings = {
  "groups": [
    {
      "name": "General",
      "sections": [
        {
          "name": "",
          "configs": [
            {
              "key": "website.settings",
              "name": "Website settings",
              "data_type": "json"
            },
            {
              "key": "website.advanced_settings",
              "name": "Advanced settings",
              "data_type": "json"
            }
          ]
        }
      ]
    }
  ]
}

WebConfig.current.add_json('website.advanced_settings', advanced_settings)
