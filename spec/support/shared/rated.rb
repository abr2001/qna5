shared_examples_for "Rated" do |model_name|
  let(:ratable) { create(model_name.to_sym, user: @user) }
  let(:foreign_ratable) { create(model_name.to_sym) }
  describe 'PATCH #cancel_rate' do
    context "author try rate #{model_name}" do
      before { post :rate, format: :json, params: { id: ratable } }
      it "not rate for #{model_name} in the database" do
        expect(question.rating).to eq 0
      end
      it { expect(response).to have_http_status(:forbidden) }
    end
    context "not author positive rate #{model_name}" do
      before { post :rate, format: :json, params: { id: foreign_ratable } }
      it "add rate for #{model_name} in the database" do
        expect(foreign_ratable.rating).to eq 1
      end
      it { expect(response).to have_http_status(:ok) }
    end
    context "not author negative rate #{model_name}" do
      before { post :rate, format: :json, params: { id: foreign_ratable, negative: true } }
      it "add rate for #{model_name} in the database" do
        expect(foreign_ratable.rating).to eq -1
      end
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'PATCH #cancel_rate' do
    let!(:rate) { create(:rate, ratable: foreign_ratable, user: @user) }
    let!(:foreign_rate) { create(:rate, ratable: ratable) }
    context "author of rate cancel rate of #{model_name}" do
      before { post :cancel_rate, format: :json, params: { id: foreign_ratable } }
      it { expect(foreign_ratable.rating).to eq 0 }
      it { expect(response).to have_http_status(:ok) }
    end
    context "not author of rate cancel rate of #{model_name}" do
      before { post :cancel_rate, format: :json, params: { id: ratable } }
      it { expect(ratable.rating).to eq 1 }
      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
