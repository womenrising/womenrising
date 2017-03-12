require 'rails_helper'

describe PeerGroup do
  context "#generate_groups" do
    let!(:users_already_grouped) do
      create_list(:skinny_user, 2, :groupable, is_assigned_peer_group: true)
    end
    let!(:users_to_be_grouped) do
      create_list(:skinny_user, 5, :groupable, is_assigned_peer_group: false)
    end

    it "Should loop through all the users and make groups" do
      groups = PeerGroup.generate_groups

      expect(User.where(is_assigned_peer_group: true).length).to eq(7)
      expect(User.where(is_assigned_peer_group: false).length).to eq(0)
      expect(PeerGroup.all.length).to be(2)
    end
  end

  context "with industry and stage of career defined" do
    let!(:startup_peers_stage_1) do
      create_list(:skinny_user, 10,
                  :groupable,
                  peer_industry: 'Startup',
                  stage_of_career: 1)
    end

    let!(:startup_peers_stage_2) do
      create_list(:skinny_user, 15,
                  :groupable,
                  peer_industry: 'Startup',
                  stage_of_career: 2)
    end

    let!(:business_peers_stage_1) do
      create_list(:skinny_user, 20,
                  :groupable,
                  peer_industry: 'Business',
                  stage_of_career: 1)
    end

    let!(:business_peers_stage_2) do
      create_list(:skinny_user, 25,
                  :groupable,
                  peer_industry: 'Business',
                  stage_of_career: 2)
    end

    let!(:technology_peers_stage_1) do
      create_list(:skinny_user, 30,
                  :groupable,
                  peer_industry: 'Technology',
                  stage_of_career: 1)
    end

    let!(:technology_peers_stage_2) do
      create_list(:skinny_user, 35,
                  :groupable,
                  peer_industry: 'Technology',
                  stage_of_career: 2)
    end

    context "#get_peers" do
      it "should get a group of peers in the same industry and stage of career" do
        group = PeerGroup.get_peers("Startup",1)
        expect(group).not_to be_empty
        expect(group.length).to eq(10)
      end
    end

    context "#get_one_peer" do
      it "should get a single" do
        peer = PeerGroup.get_one_peer(PeerGroup.get_peers("Startup",1))
        expect(startup_peers_stage_1).to include(peer)
      end
    end

    context "#remove_peer(group, peer)" do
      it "should get a single" do
        group = PeerGroup.get_peers("Startup",1)
        peer = PeerGroup.get_one_peer(group)

        new_group = PeerGroup.remove_peer(group, peer)
        expect(new_group.length).to eq(group.length - 1)

        expect(new_group).to_not include(peer)
      end
    end

    context "#create_groups" do
      it "Should assign all users with Tech and stage 1 careers to groups" do
        peer_groups = PeerGroup.create_groups([],"Technology", 1)
        expect(peer_groups.flatten.length).to eq(30)
      end
    end
  end

  context "with specific users" do
    let(:wine_group) do
      create_list(:skinny_user, 2,
                  :groupable,
                  current_goal: "Finding work/life balance",
                  top_3_interests: ["Wine"] + [
                    "Arts", "Music", "Crafting", "Home improvement / Decorating",
                    "Being a mom", "Dogs", "Watching Sports", "Outdoors / Hiking", "Exercise",
                    "Biking", "Yoga", "Running", "Beer", "Traveling", "Local events",
                    "Reading", "Photography", "Movies", "Cooking / Eating / Being a foodie",
                    "Social issues / volunteering", "Video Games"
                  ].sample(2))
    end

    let(:cats_group) do
      create_list(:skinny_user, 5,
                  :groupable,
                  top_3_interests: ["Cats"] + [
                    "Arts", "Music", "Crafting", "Home improvement / Decorating",
                    "Being a mom", "Dogs", "Watching Sports", "Outdoors / Hiking", "Exercise",
                    "Biking", "Yoga", "Running", "Beer", "Wine", "Traveling", "Local events",
                    "Reading", "Photography", "Movies", "Cooking / Eating / Being a foodie",
                    "Social issues / volunteering", "Video Games"
                  ].sample(2))
    end

    let(:cats_user_1) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["Anime", "Cats", "Mom"])
    end

    let(:cats_user_2) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["Mom", "Cats", "Hiking"])
    end

    let(:cats_user_3) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["Frogs", "Cats", "Beer"])
    end

    let(:full_cats_group) { [cats_user_1, cats_user_2, cats_user_3] }

    let(:cats_user_4) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["puppies", "Cats", "bats"])
    end

    let(:cat_peer) do
      create(:skinny_user,
            :groupable,
            current_goal: "Finding work/life balance",
            top_3_interests: ["Anime", "Cats", "Fruit"])
    end

    let(:cat_user_with_different_goal) do
      create(:skinny_user,
            :groupable,
            current_goal: "Switching Industries",
            top_3_interests: ["Anime", "Cats", "Fruit"])
    end

    let(:user_doesnt_like_cats) do
      create(:skinny_user,
            :groupable,
            current_goal: "Finding work/life balance",
            top_3_interests: ["Anime", "Animals", "Fruit"])
    end

    let(:yoga_user) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["Puppies", "Yoga", "Bats"])
    end

    let(:yoga_group) { [yoga_user] }

    let(:yoga_user_2) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["Anime", "Yoga", "Bats"])
    end

    context "#check_interests" do
      it "Should return false if there is not a common interest" do
        expect(PeerGroup.check_interests(cats_group, user_doesnt_like_cats)).to eq(false)
      end

      it "Should return true if there is a common interest" do
        peer = cats_group.pop
        expect(PeerGroup.check_interests(cats_group, peer)).to eq(true)
      end
    end

    context "#get_group_interests" do
      it "should return an array of common interests" do
        group = [cats_user_1, cats_user_2]
        expect(PeerGroup.get_group_interests(group)).not_to be_empty
        expect(PeerGroup.get_group_interests(group)).to eq(["Cats","Mom"])
       end
    end

    context "#check_group" do
      it "should return true if valid" do
        group = [cats_user_1, cats_user_2]
        expect(PeerGroup.check_group(group, cat_peer)).to eq(true)
      end

      it "should return false if they don't have the same current_goal" do
        group = [cats_user_1, cats_user_2]
        expect(PeerGroup.check_group(group, cat_user_with_different_goal)).to be(false)
      end

      it "should return false if invalid interests" do
        group = [cats_user_1, cats_user_2]
        expect(PeerGroup.check_group(group, user_doesnt_like_cats)).to be(false)
      end
    end

    context "#assign_group" do
      let(:cats_group) { [cats_user_1, cats_user_2] }

      it "It will add a person to a group that they will fit in with" do
        groups = [cats_group, yoga_group, wine_group]

        new_groups = PeerGroup.assign_group(groups, yoga_user_2)
        expect(new_groups.length).to eq(3)
        yoga_group = new_groups.select{|g| g.include?(yoga_user)}.first

        expect(yoga_group.length).to eq(2)
        expect(yoga_group).to include(yoga_user_2)
      end

      it "should not add the person to a group that is already full"  do
        groups = [full_cats_group, cats_group, yoga_group]

        new_groups = PeerGroup.assign_group(groups, cat_peer)

        expect(new_groups.length).to eq(3)
        expect(new_groups[0].length).to eq(3)
        expect(new_groups[1].length).to eq(3)
        expect(new_groups[1][2]).to be(cat_peer)
        expect(new_groups[2].length).to eq(1)
      end

      it "should add a group at the end if none of the other groups match" do
        groups = [full_cats_group, cats_group, yoga_group]

        new_groups = PeerGroup.assign_group(groups, user_doesnt_like_cats)
        expect(new_groups.length).to eq(4)
      end
    end

    context "#assign_group_no_common_current_goal" do
      it "should assign peer based on interest and does not care about goal" do
        other_cat_group = [cats_user_4]
        groups = [full_cats_group, wine_group, other_cat_group]

        new_groups = PeerGroup.assign_group_no_common_current_goal(groups, cat_user_with_different_goal)
        expect(new_groups.length).to eq(3)

        new_other_cat_group = new_groups.select{|g| g.include?(cats_user_4)}.first
        expect(new_other_cat_group.length).to eq(2)
        expect(new_other_cat_group).to include(cat_user_with_different_goal)
      end

      it "should assign peer based on interest" do
        cats_group = [cats_user_1, cats_user_2]
        other_cats_group = [cats_user_3, cats_user_4]
        groups = [cats_group, yoga_group, other_cats_group]

        new_groups = PeerGroup.assign_group_no_common_current_goal(groups, cat_user_with_different_goal)
        expect(new_groups.length).to eq(3)

        new_cats_group = new_groups.select{|g| g.include?(cats_user_1)}.first
        expect(new_cats_group.length).to eq(3)
        expect(new_cats_group).to include(cat_user_with_different_goal)
      end

      it "should create a new one if doesn't fit in any" do
        peer = create(:skinny_user,
                      :groupable,
                      :new_to_technology,
                      current_goal: "Switching Industries",
                      top_3_interests: ["Anime", "Hiking","Fruit"])
        groups = [full_cats_group, yoga_group, wine_group]

        new_groups = PeerGroup.assign_group_no_common_current_goal(groups, peer)
        expect(new_groups.length).to eq(4)

        new_group = new_groups.select{|g| g.include?(peer)}.first
        expect(new_group.length).to eq(1)
      end
    end
  end

  context "outlyers" do
    let(:group_of_4) do
      create_list(:skinny_user, 4,
                  :groupable,
                  :new_to_technology_and_wants_balance,
                  top_3_interests: ["Anime", "Cats", "Mom"])
    end

    let!(:cats_users) do
      create_list(:skinny_user, 3,
                  :groupable,
                  :new_to_technology_and_wants_balance,
                  top_3_interests: ["Anime", "Cats", "Mom"])
    end

    let!(:yoga_users) do
      create_list(:skinny_user, 3,
                  :groupable,
                  :new_to_technology_and_wants_balance,
                  top_3_interests: ["Puppies", "Yoga", "Bats"])
    end

    let!(:hiking_users) do
      create_list(:skinny_user, 2,
                  :groupable,
                  :new_to_technology_and_wants_balance,
                  top_3_interests: ["Hiking", "Fruit", "Puppies"])
    end

    let!(:art_users) do
      create_list(:skinny_user, 2,
                  :groupable,
                  :new_to_technology_and_wants_balance,
                  top_3_interests: ["Arts", "Music", "Crafting"])
    end

    let!(:other_peer) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["Home improvement / Decorating", "Being a mom", "Dogs"])
    end

    let!(:art_user_with_different_goal) do
      create(:skinny_user,
            :groupable,
            :new_to_technology,
            current_goal: "Switching Industries",
            top_3_interests: ["Arts", "Music", "Crafting"])
    end

    let!(:exercise_user) do
      create(:skinny_user,
            :groupable,
            :new_to_technology_and_wants_balance,
            top_3_interests: ["Biking", "Watching Sports", "Exercise"])
    end

    let(:all_groups) do
      [cats_users, yoga_users, hiking_users, art_users, [other_peer],
      [art_user_with_different_goal], [exercise_user]]
    end

    let(:full_groups) {[cats_users, yoga_users]}

    let(:outliers) do
      [hiking_users, art_users, [other_peer], [art_user_with_different_goal], [exercise_user]]
    end

    context "#get_singles" do
      it "should get all groups with just one person in it" do
        single_groups = PeerGroup.get_singles(all_groups)
        expect(single_groups.length).to eq(3)
        expect(single_groups).to eq([[other_peer],[art_user_with_different_goal],[exercise_user]])
      end
    end

    context "#get_not_full_groups" do
      it "Should return a array of the groups that were are not complete" do
        not_full_groups = PeerGroup.get_not_full_groups(all_groups)
        expect(not_full_groups.length).to eq(5)
        expect(not_full_groups).to eq(outliers)
      end

      it "Should return an empty array if nothing is found" do
        full_groups = cats_users, yoga_users
        peer_groups = PeerGroup.get_not_full_groups(full_groups)
        expect(peer_groups.length).to eq(0)
        expect(peer_groups).to eq([])
      end
    end

    context "#reassign_not_full_groups" do
      it "removes a user from outliers and assigns them to a group" do
        peer_groups = PeerGroup.reassign_not_full_groups(full_groups, outliers)
        expect(peer_groups.length).to eq(6)

        new_art_group = peer_groups.select{|g| g.include?(art_user_with_different_goal)}.first
        expect(new_art_group.length).to eq(3)

        new_outliers = PeerGroup.get_not_full_groups(peer_groups)
        expect(new_outliers.length).to eq(3)
        expect(new_outliers.select{|g| g.include?(art_user_with_different_goal)}.first).to be_nil
      end
    end

    context "#assign_to_group_of_three" do
      it "should assign a peer to a group of three" do
        groups = cats_users, art_users
        new_groups = PeerGroup.assign_to_group_of_three(groups, other_peer)

        expect(new_groups.length).to eq(2)
        expect(new_groups[0].length).to eq(4)
        expect(new_groups[0]).to eq([
          cats_users.first, cats_users.second, cats_users.third, other_peer
        ])
      end

      it "should not assign the peer to a group of 4" do
        groups = group_of_4, art_users
        new_groups = PeerGroup.assign_to_group_of_three(groups, other_peer)

        expect(new_groups.length).to eq(2)
        expect(new_groups[0].length).to eq(4)
        expect(new_groups[1]).to eq([art_users.first, art_users.second, other_peer])
      end
    end

    context "#assign_group_no_checks" do
      let!(:groups) {[cats_users, group_of_4, yoga_users]}

      let(:peer_1) do
        create(:skinny_user,
              :groupable,
              :new_to_technology_and_wants_balance,
              top_3_interests: ["Anime", "Hiking", "Bats"])
      end

      let(:peer_2) do
        create(:skinny_user,
              :groupable,
              :new_to_technology_and_wants_balance,
              top_3_interests: ["Mom", "Cats", "Hiking"])
      end

      it 'should create new group if there are at least 3 peers' do
        peer_3 = create(:skinny_user,
                        :groupable,
                        :new_to_technology_and_wants_balance,
                        top_3_interests: ["Frogs", "Hiking", "Beer"])

        peer_4 = create(:skinny_user,
                        :groupable,
                        :new_to_technology_and_wants_balance,
                        top_3_interests: ["puppies", "yoga", "bats"])

        peers = [peer_1, peer_2, peer_3, peer_4]
        new_groups = PeerGroup.assign_group_no_checks(groups, peers)
        expect(new_groups.length).to eq(4)
      end

      it 'should not create new groups if there are less than 3 peers' do
        peers = [peer_1, peer_2]
        new_groups = PeerGroup.assign_group_no_checks(groups, peers)

        expect(new_groups.length).to eq(3)
      end
    end

    it "should make groups out of remainder" do
      ungrouped_users = User.where(is_participating_this_month: true,
                                   waitlist: false, live_in_detroit: true,
                                   is_assigned_peer_group: false)
      expect(ungrouped_users.length).to eq(13)
      PeerGroup.generate_groups
      new_ungrouped_users = User.where(is_participating_this_month: true,
                                       waitlist: false,
                                       live_in_detroit: true,
                                       is_assigned_peer_group: false)
      expect(new_ungrouped_users.length).to eq(0)
    end
  end

  context "with 200 random users that can be grouped" do
    before do
      create_list(:skinny_user, 200, :groupable, :any_stage_of_career)
    end

    context "#automatially_create_groups" do
      before do
        @start_group = User.all
        @groups = PeerGroup.organize_into_groups!(@start_group)
      end

      it "should loop through and assign groups" do
        expect(@groups.flatten.length).to eq(@start_group.length)
        expect(@groups.is_a?(Array)).to be(true)
      end
    end
  end
end
