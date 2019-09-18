require "spec_helper"

RSpec.describe Trustdock::Client do
  # This api token for just testing
  let(:api_token) { "api_token" }
  let(:plan_id) { "924af311-788f-4252-9b6d-bef2bc0871ae" }
  let(:base64_image) { "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bS0UrDnYQPyBDdbIgKuKoVShChVArtOpgcukXNGlIUlwcBdeCgx+LVQcXZ10dXAVB8APExdVJ0UVK/F9SaBHjwXE/3t173L0D/PUyU82OcUDVLCOViAuZ7KoQekUQw+hGGIMSM/U5UUzCc3zdw8fXuxjP8j735+hRciYDfALxLNMNi3iDeHrT0jnvE0dYUVKIz4nHDLog8SPXZZffOBcc9vPMiJFOzRNHiIVCG8ttzIqGSjxFHFVUjfL9GZcVzluc1XKVNe/JXxjOaSvLXKc5hAQWsQQRAmRUUUIZFmK0aqSYSNF+3MM/4PhFcsnkKoGRYwEVqJAcP/gf/O7WzE9OuEnhOBB8se2PESC0CzRqtv19bNuNEyDwDFxpLX+lDsx8kl5radEjoHcbuLhuafIecLkD9D/pkiE5UoCmP58H3s/om7JA3y3Qteb21tzH6QOQpq6SN8DBITBaoOx1j3d3tvf275lmfz85tnKQCfSDXgAAAAxJREFUCNdj+DhjBQAErwIyZjaCMwAAAABJRU5ErkJggg==" }

  describe "#create_verification" do
    it "calls create verification API" do
      client = Trustdock::Client.new(api_token, sandbox: true)

      VCR.use_cassette("create_verification") do
        verification = client.create_verification

        expect(client.last_response.status).to eq 202
        expect(verification).to be_a Trustdock::Response::Verification
      end
    end
  end

  describe "#verification" do
    it "calls verification API" do
      client = Trustdock::Client.new(api_token, sandbox: true)

      VCR.use_cassette("verification") do
        verification = client.create_verification
        verification = client.verification(verification.id)

        expect(client.last_response.status).to eq 200
        expect(verification).to be_a Trustdock::Response::Verification
      end
    end
  end

  describe "#update_plan" do
    it "calls update plan API" do
      client = Trustdock::Client.new(api_token, sandbox: true)

      VCR.use_cassette("update_plan") do
        verification = client.create_verification
        response = client.update_plan(verification.id, { ids: [plan_id] })

        expect(client.last_response.status).to eq 204
        expect(response).to eq nil
      end
    end
  end

  describe "#update_document" do
    it "calls update document API" do
      client = Trustdock::Client.new(api_token, sandbox: true)

      VCR.use_cassette("update_document") do
        verification = client.create_verification
        client.update_plan(verification.id, { ids: [plan_id] })

        params = {
          "id_document": {
            "type": "passport",
            "format": "image",
            "data": {
              "front": [
                base64_image
              ],
              "back": [
                base64_image
              ]
            }
          }
        }

        response = client.update_document(verification.id, plan_id, params)

        expect(client.last_response.status).to eq 204
        expect(response).to eq nil
      end
    end
  end

  describe "#update_comparing_data" do
    it "calls update comparing data API" do
      client = Trustdock::Client.new(api_token, sandbox: true)

      VCR.use_cassette("update_comparing_data") do
        verification = client.create_verification
        client.update_plan(verification.id, { ids: [plan_id] })

        params = {
          "id_document": {
            "type": "passport",
            "format": "image",
            "data": {
              "front": [
                base64_image
              ],
              "back": [
                base64_image
              ]
            }
          }
        }

        client.update_document(verification.id, plan_id, params)

        params = {
          "name": "日本花子",
          "birth": "1975-06-01",
          "address": "三重県津市垂水2566番地",
          "gender": "female"
        }

        response = client.update_comparing_data(verification.id, params)

        expect(client.last_response.status).to eq 204
        expect(response).to eq nil
      end
    end
  end
end
