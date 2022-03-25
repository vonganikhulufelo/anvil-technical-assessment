require 'rails_helper'

RSpec.describe "Members", type: :request do

  before(:all) do
    Member.destroy_all();
    @member = Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1);
    Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani1@gmail.com',birthday: DateTime.now,games_played: 1,rank: 2);
    Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani2@gmail.com',birthday: DateTime.now,games_played: 1,rank: 3);
    Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani3@gmail.com',birthday: DateTime.now,games_played: 1,rank: 4);
    Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani4@gmail.com',birthday: DateTime.now,games_played: 1,rank: 5
    );
    @members = Member.all();
    @member_id = @member.id;
  end


  # index action
  describe 'GET /members' do
    before { get '/members' }

    it 'returns members' do
      expect(@members).not_to be_empty
      expect(@members.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

    # new action
    describe 'GET #new' do
      before do
        get '/members/new'
      end
  
      it 'is expected to assign member as new instance variable' do
        expect(assigns[:member]).to be_instance_of(Member)
      end
  
      it 'renders new template' do
        is_expected.to render_template(:new)
      end
  
      it 'renders application layout' do
        is_expected.to render_template(:application)
      end
    end
  
    # create action
    describe 'POST #create' do
      before do
        post '/members', params: params
      end
  
      context 'when params are correct' do
        let(:params) { { member: { name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 0,rank: Member.all().count().to_i + 1 } } }
  
        it 'is expected to create new member successfully' do
          expect(assigns[:member]).to be_instance_of(Member)
        end
  
        it 'is expected to have name assigned to it' do
          expect(assigns[:member].name).to eq('vongani')
        end
  
        it 'is expected to redirect to users path' do
          is_expected.to redirect_to member_path(assigns[:member])
        end
      end
  
      context 'when params are not correct' do
        let(:params) { { member: { name: '' } } }
  
        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end
  
        it 'is expected to add errors to name attribute' do
          expect(assigns[:member].errors[:name]).to eq(['can\'t be blank'])
        end
      end
    end
  
    # edit action
    describe 'GET #edit' do
      before do
        get edit_member_url(params)
      end
  
      context 'when member id is valid' do
        let(:member) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1) }
        let(:params) { { id: member.id } }
  
        it 'is expected to set member instance variable' do
          expect(assigns[:member]).to eq(Member.find_by(id: params[:id]))
        end
  
        it 'is expected to render edit template' do
          is_expected.to render_template(:edit)
        end
      end
  
      context 'when member id is invalid' do
        let(:params) { { id: 0 } }
  
        it 'is expected to redirect_to members path' do
          is_expected.to redirect_to(members_path)
        end
      end
  
    end
  
    # update action
    describe 'PATCH #update' do
  
      before do
        put '/members/:id', :params => {id: params} 
      end
  
      context 'when member not found' do
        let(:params) { { id: 0 } }
        
        it 'is expected to redirect_to members path' do
          is_expected.to redirect_to(members_path)
        end
      end
          
      context 'when data is provided is valid' do
        
        let(:member) { @member }
        let(:params) { { id: @member.id, member: { name: 'test name' } } }

        it 'is_expected to redirect_to members_path' do
          is_expected.to redirect_to(members_path)
        end
      end

      context 'when data is invalid' do
        let(:member) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1) }
        let(:params) { { id: 0, member: { name: '',surname: '' } } }
        
        it 'is expected not to update member name' do
          expect(member.reload.name).not_to be_empty
        end
      end
    end

     # action destroy
    describe 'DELETE /members/:id' do
      before do
      end
      
      let(:member) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1) }
      let(:params) { { id: member } }
      it 'rediect to members path' do
        delete "/members/:id", :params => {:id => member.id}
        is_expected.to redirect_to(members_path)
      end
      it "deletes member" do    
        delete "/members/:id", :params => {:id => member.id}
        expect { member.destroy }.to change { Member.count }.by(-1)
    
        expect(Member.all.count).to be 5
      end  
    end
     # action rank
    describe 'get /rank/:id' do
      before do
        get rank_url(params)
      end
      
      let(:member) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1) }
      let(:params) { { id: member.id } }
      
      context 'when rank id is valid' do
  
        it 'is expected to set member instance variable' do
          expect(assigns[:member]).to eq(Member.find_by(id: params[:id]))
        end
  
        it 'is expected to render rank template' do
          is_expected.to render_template(:rank)
        end
      end
    end
     # action rank update score
    describe 'get /rank/:id' do
      before do
        Member.destroy_all();
        get rank_update_url(params)
      end
      
      let(:member) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1) }
      let(:member2) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 2) }
      let(:params) { { id: member.id, rank_update: {member_id: member2.id, score: 'win'} } }
      
      context 'when update score with Win' do
  
        it 'if the higher-ranked player wins against their opponent, neither of their ranks change' do
          expect(assigns[:member]).to eq(Member.find_by(id: params[:id]))
          expect { member.rank }.to change { Member.find(member.id).rank }.by(0)
        end
      end
      context 'when update score with draw' do
        let(:member) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 3) }
        let(:member2) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 2) }
        let(:member3) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1) }
        let(:params) { { id: member.id, rank_update: {member_id: member3.id, score: 'Draw'} } }
        it 'the lower-ranked player can gain one position' do
          expect { member.rank }.to change { Member.find(member.id).rank }.by(0)
        end
        it 'two players are adjacent' do
          expect(member.rank).to eq(3)
        end
        it 'if the players are ranked 1th and 3th, and it’s a draw, the player with rank 3 will move up to rank 14 and the player with rank 1 will stay the same' do
          expect { member.rank }.to change { Member.find(member.id).rank }.by(0)
        end
  
      end

      context 'when update score with Loose' do
        let(:member) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 3) }
        let(:member2) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 2) }
        let(:member3) { Member.create(name: 'vongani', surname: 'Mahumani', email: 'vongani@gmail.com',birthday: DateTime.now,games_played: 1,rank: 1) }
        let(:params) { { id: member.id, rank_update: {member_id: member3.id, score: 'Draw'} } }
        it 'If the lower-ranked player beats a higher-ranked player, the higher-ranked player will move one rank down, and the lower level player will move up by half the difference between their original 
        ranks' do
          expect(assigns[:member].rank).to eq(3)
          member.reload
          expect { assigns[:member].rank }.to change { Member.find(member.id).rank }.by(0)
        end
      end
    end
  end
