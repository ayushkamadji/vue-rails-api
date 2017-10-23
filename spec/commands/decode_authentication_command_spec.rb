# frozen_string_literal: true

describe DecodeAuthenticationCommand do
  include ActiveSupport::Testing::TimeHelpers

  context 'without token' do
    subject { described_class.call('') }

    it { expect(subject.success?).to_not be }
    it { expect(subject.errors.keys).to include(:token) }
    it { expect(subject.errors.values.flatten).to include('Token missing') }
  end

  context 'with expired token' do
    let!(:user) { create(:user, id: 1) }
    let(:expired_header) do
      {
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE0ODMzMTUyMDF9.bR7d1-AsdUxmdC21dhL563CZWfCEdoDSQbRhH41_IT0'
      }
    end

    subject { described_class.call(expired_header) }

    it { expect(subject.success?).to_not be }
    it { expect(subject.errors.keys).to include(:token) }
    it { expect(subject.errors.values.flatten).to include('Token expired') }
  end

  context 'with invalid token' do
    before { travel_to Time.zone.local(2017, 1, 1) }
    after { travel_back }

    let(:expired_header) do
      {
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE0ODMzMTUyMDF9.bR7d1-AsdUxmdC21dhL563CZWfCEdoDSQbRhH41_IT0'
      }
    end

    subject { described_class.call(expired_header) }

    it { expect(subject.success?).to_not be }
    it { expect(subject.errors.keys).to include(:token) }
    it { expect(subject.errors.values.flatten).to include('Token invalid') }
  end

  context 'with valid token' do
    before { travel_to Time.zone.local(2017, 1, 1) }
    after { travel_back }
    let!(:user) { create(:user, id: 1) }

    let(:expired_header) do
      {
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE0ODMzMTUyMDF9.bR7d1-AsdUxmdC21dhL563CZWfCEdoDSQbRhH41_IT0'
      }
    end

    subject { described_class.call(expired_header) }

    it { expect(subject.success?).to be }
    it { expect(subject.errors).to be_empty }
  end
end
