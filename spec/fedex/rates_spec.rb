RSpec.describe Fedex::Rates do
	it "Returns valid data" do

		# User Credentials
    credentials = {
			user_credential: {
				key: "bkjIgUhxdghtLw9L",
				password: "6p8oOccHmDwuJZCyJs44wQ0Iw"
			},
				user_details: {
				accoun_number: "510087720",
				meter_number: "119238439"
			}
    }

    # Quote params
    quote_params = {
			address_from: {
				zip: "64000",
				country: "MX"
			},
			address_to: {
				zip: "06500",
				country: "MX"
			},
			parcel: {
				length: 25,
				witdh: 28,
				height: 46,
				distance_unit: "CM",
				weight: 6.5,
				mass_unit: "KG"
			}
    }

    response = Fedex::Rates.get(credentials, quote_params)

		puts response
    
    expect(response).not_to be nil
    end
  end