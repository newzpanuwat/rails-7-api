require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  # const
  API_V1 = '/api/v1'

  describe "#GET" do
    describe "#index" do
      before do 
        FactoryBot.create_list(:category, 5)
        get "#{API_V1}/categories"
      end

      it 'returns categories' do
        expect(json['categories'].size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end
    end

    describe "#show" do
      context 'with valid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          get "#{API_V1}/categories/#{my_category.id}", params: { id: my_category.id }
        end

        it 'returns the name' do
          expect(json['category']['name']).to eq(my_category.name)
        end

        it 'returns a created status' do
          expect(response.status).to eq(200)
        end
      end

      context 'with invalid parameters' do
        before do
          get "#{API_V1}/categories/#{20}", params: { id: 20 }
        end

        it 'returns status code 404' do
          expect(response.status).to eq(404)
        end
      end
    end
  end

  describe "#POST" do
    describe "#create" do
      context 'with valid parameters' do
        before do
          post "#{API_V1}/categories", params:
                            { category: {
                              name: 'Cat 1'
                            } }
        end

        it 'returns the name' do
          expect(json['category']['name']).to eq('Cat 1')
        end

        it 'returns a created status' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          post "#{API_V1}/categories", params:
                            { category: { 
                              name: Faker::Lorem.characters(number: 200)
                            } }
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invalid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          post "#{API_V1}/categories", params:
                            { category: { 
                              name: ''
                            } }
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'duplicated category name' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          post "#{API_V1}/categories", params:
                            { category: { 
                              name: my_category.name
                            } }
        end

        it 'returns a bad request status' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe "#PATCH" do
    describe "update" do
      context 'with valid parameters' do
        let!(:my_category) { FactoryBot.create(:category) }

        before do
          patch "#{API_V1}/categories/#{my_category.id}", params:
                            { category: {
                              id: my_category.id,
                              name: 'New Category'
                            } }
        end

        it 'returns the name' do
          expect(json['category']['name']).to eq('New Category')
        end

        it 'returns a created status' do
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#DELETE" do
    describe "destroy" do
      let!(:category) { FactoryBot.create(:category) }

      before do
        delete "#{API_V1}/categories/#{category.id}", params: { id: category.id }
      end

      it 'returns status code 200' do
        expect(response.status).to eq(200)
      end

      it 'returns 0 category' do
        expect(Category.count).to eq(0)
      end
    end
  end
end
