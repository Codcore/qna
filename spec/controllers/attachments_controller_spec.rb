require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) { create(:user)}
  let(:another_user) { create(:user)}

  let!(:question) { create(:question, author: user) }
  let!(:answer_with_attachment) { create(:answer, :with_files, question: question, author: user) }

  describe 'DELETE #destroy' do
    context 'when user is an author' do
      before { login user}

      it 'should find and delete attachment by id' do
        expect do
          delete :destroy, params: { id: answer_with_attachment.files.last}, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'should render :destroy view' do
        delete :destroy, params: { id: answer_with_attachment.files.last }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when user is not author' do
      before { login another_user}

      it 'should not delete attachment by id' do
        expect do
          delete :destroy, params: { id: answer_with_attachment.files.last }, format: :js
        end.not_to change(ActiveStorage::Attachment, :count)
      end

      it 'should return 403 Forbidden status' do
        delete :destroy, params: { id: answer_with_attachment.files.last }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end
end
