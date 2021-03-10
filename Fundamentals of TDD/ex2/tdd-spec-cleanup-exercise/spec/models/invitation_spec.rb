require "rails_helper"

RSpec.describe Invitation do
  # before do
  #   team.update!(owner: team_owner)
  #   team_owner.update!(team: team)
  # end

  # let(:invitation) { build(:invitation, team: team, user: new_user) }
  # let(:new_user) { create(:user, email: "rookie@example.com") }
  # let(:team) { create(:team, name: "A fine team") }
  # let(:team_owner) { create(:user) }

  describe "callbacks" do
    describe "after_save" do
      context "with valid data" do
        it "invites the user" do

          team_owner = create_team_owner
          new_user = create_new_user
          team = create_team
          update_team_owner_with_team(team_owner, team)
          update_team_with_owner(team,team_owner)
          invitation = build_invitation(team, new_user)

          invitation.save

          expect(new_user).to be_invited
        end
      end

      context "with invalid data" do
        # before do
        #   invitation.team = nil
        #   invitation.save
        # end
        it "does not save the invitation" do

          team_owner = create_team_owner
          new_user = create_new_user
          team = create_team
          update_team_owner_with_team(team_owner, team)
          update_team_with_owner(team,team_owner)
          invitation = build_invitation(nil, new_user)
          invitation.save
          
          expect(invitation).not_to be_valid
          expect(invitation).to be_new_record
        end

        it "does not mark the user as invited" do
          team_owner = create_team_owner
          new_user = create_new_user
          team = create_team
          update_team_owner_with_team(team_owner, team)
          update_team_with_owner(team,team_owner)
          invitation = build_invitation(nil, new_user)
          invitation.save
          
          expect(new_user).not_to be_invited
        end
      end
    end
  end

  describe "#event_log_statement" do
    context "when the record is saved" do
      it "include the name of the team" do
        team_owner = create_team_owner
        new_user = create_new_user
        team = create_team
        update_team_owner_with_team(team_owner, team)
        update_team_with_owner(team,team_owner)
        invitation = build_invitation(team, new_user)
        invitation.save
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("A fine team")
      end

      it "include the email of the invitee" do
        team_owner = create_team_owner
        new_user = create_new_user
        team = create_team
        update_team_owner_with_team(team_owner, team)
        update_team_with_owner(team,team_owner)
        invitation = build_invitation(team, new_user)
        invitation.save
        log_statement = invitation.event_log_statement

        expect(log_statement).to include("rookie@example.com")
      end
    end

    context "when the record is not saved but valid" do
      it "includes the name of the team" do
        team_owner = create_team_owner
        new_user = create_new_user
        team = create_team
        update_team_owner_with_team(team_owner, team)
        update_team_with_owner(team,team_owner)
        invitation = build_invitation(team, new_user)
        invitation.save
        log_statement = invitation.event_log_statement

        expect(log_statement).to include("A fine team")
      end

      it "includes the email of the invitee" do
        team_owner = create_team_owner
        new_user = create_new_user
        team = create_team
        update_team_owner_with_team(team_owner, team)
        update_team_with_owner(team,team_owner)
        invitation = build_invitation(team, new_user)
        invitation.save
        log_statement = invitation.event_log_statement

        expect(log_statement).to include("rookie@example.com")
      end

      it "includes the word 'PENDING'" do
        team_owner = create_team_owner
        new_user = create_new_user
        team = create_team
        update_team_owner_with_team(team_owner, team)
        update_team_with_owner(team,team_owner)
        invitation = build_invitation(team, new_user)
        log_statement = invitation.event_log_statement

        expect(log_statement).to include("PENDING")
      end
    end

    context "when the record is not saved and not valid" do
      it "includes INVALID" do
        team_owner = create_team_owner
        new_user = create_new_user
        team = create_team
        update_team_owner_with_team(team_owner, team)
        update_team_with_owner(team,team_owner)
        invitation = build_invitation(team, new_user)
        invitation.user = nil
        invitation.save
        log_statement = invitation.event_log_statement
        
        expect(log_statement).to include("INVALID")
      end
    end
  end

  def create_new_user
    create(:user, email:"rookie@example.com")
  end

  def create_team_owner
    create(:user)
  end

  def create_team
    create(:team, name:"A fine team")
  end

  def update_team_owner_with_team(team_owner,team)

      team_owner.update!(team: team)
  end

  def update_team_with_owner(team, team_owner)
      team.update!(owner: team_owner)
  end

  def build_invitation(team, user)
    build(:invitation, team:team, user:user)
  end
end
