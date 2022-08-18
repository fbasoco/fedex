# frozen_string_literal: true

require "nokogiri"
require "httparty"

module Fedex
  class Rates
    URL = "https://wsbeta.fedex.com:443/xml/"

    def self.get(credentials, quote_params)
      puts "Credentials: "
      puts credentials

      puts "Quote params: "
      puts quote_params

      xml_body = request_body(credentials, quote_params)
      puts xml_body

      response = HTTParty.post(URL, body: xml_body)

      response_data(response)
    end

    def self.test
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

      request_body(credentials, quote_params)

      get(credentials, quote_params)
    end

    def self.request_body(credentials, quote_params)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.RateRequest(xmlns: "http://fedex.com/ws/rate/v13") do
          xml.WebAuthenticationDetail do
            xml.UserCredential do
              xml.Key credentials[:user_credential][:key].to_s # "bkjIgUhxdghtLw9L"
              xml.Password credentials[:user_credential][:password].to_s # "6p8oOccHmDwuJZCyJs44wQ0Iw"
            end
          end
          xml.ClientDetail do
            xml.AccountNumber credentials[:user_details][:accoun_number].to_s # "510087720"
            xml.MeterNumber credentials[:user_details][:meter_number].to_s # "119238439"
            xml.Localization do
              xml.LanguageCode "es"
              xml.LocaleCode "mx"
            end
          end
          xml.Version do
            xml.ServiceId "crs"
            xml.Major 13
            xml.Intermediate 0
            xml.Minor 0
          end
          xml.ReturnTransitAndCommit "true"
          xml.RequestedShipment do
            xml.DropoffType "REGULAR_PICKUP"
            xml.PackagingType "YOUR_PACKAGING"
            xml.Shipper do
              xml.Address do
                xml.StreetLines " "
                xml.City " "
                xml.StateOrProvinceCode "XX"
                xml.PostalCode quote_params[:address_from][:zip].to_s
                xml.CountryCode quote_params[:address_from][:country].to_s
              end
            end
            xml.Recipient do
              xml.Address do
                xml.StreetLines {}
                xml.City {}
                xml.StateOrProvinceCode "XX"
                xml.PostalCode quote_params[:address_to][:zip].to_s
                xml.CountryCode quote_params[:address_to][:country].to_s
              end
            end
            xml.ShippingChargesPayment do
              xml.PaymentType "SENDER"
            end
            xml.RateRequestTypes "ACCOUNT"
            xml.PackageCount 1
            xml.RequestedPackageLineItems do
              xml.GroupPackageCount 1
              xml.Weight do
                xml.Units quote_params[:parcel][:mass_unit].to_s
                xml.Value quote_params[:parcel][:weight]
              end
              xml.Dimensions do
                xml.Length quote_params[:parcel][:length].to_i
                xml.Width quote_params[:parcel][:witdh].to_i
                xml.Height quote_params[:parcel][:height].to_i
                xml.Units quote_params[:parcel][:distance_unit].to_s
              end
            end
          end
        end
      end

      builder.to_xml
    end

    def self.response_data(response)
      data = []

      response.parsed_response["RateReply"]["RateReplyDetails"].each do |rate_reply_detail|
        next unless rate_reply_detail.key?("ServiceType")

        data << {
          price: rate_reply_detail["RatedShipmentDetails"][0]["ShipmentRateDetail"]["TotalNetChargeWithDutiesAndTaxes"]["Amount"],
          currency: rate_reply_detail["RatedShipmentDetails"][0]["ShipmentRateDetail"]["TotalNetChargeWithDutiesAndTaxes"]["Currency"],
          service_level: {
            name: rate_reply_detail["ServiceType"].gsub("_", " ").capitalize,
            token: rate_reply_detail["ServiceType"]
          }
        }
      end

      data
    end
  end
end
