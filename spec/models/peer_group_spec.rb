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
      PeerGroup.generate_groups

      expect(User.where(is_assigned_peer_group: true).length).to eq(7)
      expect(User.where(is_assigned_peer_group: false).length).to eq(0)
      expect(PeerGroup.all.length).to be(1)
    end
  end

  context "with industry and stage of career defined" do
    let!(:startup_peers) do
      create_list(:skinny_user, 10,
        :groupable,
        peer_industry: 'Startup',
        stage_of_career: 1)
    end

    let!(:different_stage) do
      create_list(:skinny_user, 50,
        :groupable,
        stage_of_career: 2)
    end

    let!(:different_industry) do
      create_list(:skinny_user, 50,
        :groupable,
        peer_industry: 'Business')
    end

    context "#self.get_peers" do
      it "should get a group of peers in the same industry and stage of career" do
        group = PeerGroup.get_peers("Startup",1)
        expect(group).not_to be_empty
        expect(group.length).to eq(10)
      end
    end

    context "#self.get_one_peer" do
      it "should get a single" do
        peer = PeerGroup.get_one_peer(PeerGroup.get_peers("Startup",1))
        expect(startup_peers).to include(peer)
      end
    end

    context "#self.remove_peer(group, peer)" do
      it "should get a single" do
        group = PeerGroup.get_peers("Startup",1)
        peer = PeerGroup.get_one_peer(group)

        new_group = PeerGroup.remove_peer(group, peer)
        expect(new_group.count).to eq(group.length - 1)

        expect(new_group).to_not include(peer)
      end
    end
  end

  context "with specific users" do
    let(:wine_group) do
      create_list(:skinny_user, 2,
        :groupable,
        current_goal: "Finding work/life balance",
        top_3_interests: ["Wine"] + ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer", "Cats", "Traveling", "Local events", "Reading", "Photography", "Movies", "Cooking / Eating / Being a foodie", "Social issues / volunteering", "Video Games"].sample(2)
      )
    end

    let(:cats_group) do
      create_list(:skinny_user, 5,
        :groupable,
        top_3_interests: ["Cats"] + ["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer", "Wine", "Traveling", "Local events", "Reading", "Photography", "Movies", "Cooking / Eating / Being a foodie", "Social issues / volunteering", "Video Games"].sample(2)
      )
    end

    let!(:cats_user_1) do
      create(:skinny_user,
        :groupable,
        :new_to_technology_and_wants_balance,
        top_3_interests: ["Anime", "Cats","Mom"])
    end

    let!(:cats_user_2) do
      create(:skinny_user,
        :groupable,
        :new_to_technology_and_wants_balance,
        top_3_interests: ["Mom", "Cats","Hiking"])
    end

    let!(:cats_user_3) do
      create(:skinny_user,
        :groupable,
        :new_to_technology_and_wants_balance,
        top_3_interests: ["Frogs", "Cats","Beer"])
    end

    let(:cat_peer) do
      create(:skinny_user,
        :groupable,
        current_goal: "Finding work/life balance",
        top_3_interests: ["Anime", "Cats","Fruit"])
    end

    let(:cat_user_with_different_goal) do
      create(:skinny_user,
        :groupable,
        current_goal: "Switching Industries",
        top_3_interests: ["Anime", "Cats","Fruit"])
    end

    let(:user_doesnt_like_cats) do
      create(:skinny_user,
        :groupable,
        current_goal: "Finding work/life balance",
        top_3_interests: ["Anime", "Animals","Fruit"])
    end

    let(:yoga_user) do
      create(:skinny_user,
        :groupable,
        :new_to_technology_and_wants_balance,
        top_3_interests: ["Puppies", "Yoga", "Bats"])
    end

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
      let(:full_cats_group) { [cats_user_1, cats_user_2, cats_user_3] }

      let(:cats_group) { [cats_user_1, cats_user_2] }

      let(:other_group) do
        [yoga_user]
      end

      it "It will add a person to a group that they will fit in with" do
        groups = [cats_group, other_group, wine_group]

        new_groups = PeerGroup.assign_group(groups, yoga_user_2)
        yoga_group = new_groups.select{|g| g.include?(yoga_user)}.first

        expect(yoga_group.length).to eq(2)
        expect(yoga_group).to include(yoga_user_2)
      end

      it "should not add the person to a group that is already full"  do
        groups = [full_cats_group, cats_group, other_group]

        new_groups = PeerGroup.assign_group(groups, cat_peer)

        expect(new_groups.count).to eq(3)
        expect(new_groups[0].length).to eq(3)
        expect(new_groups[1].length).to eq(3)
        expect(new_groups[1][2]).to be(cat_peer)
        expect(new_groups[2].length).to eq(1)
      end

      it "should add a group at the end if none of the other groups match" do
        groups = [full_cats_group, cats_group, other_group]

        new_groups = PeerGroup.assign_group(groups, user_doesnt_like_cats)
        expect(new_groups.length).to eq(4)
      end
    end
  end

  context "with 100 random users" do
    before do
      create_list(:user, 100)
    end

    context "#automatially_create_groups" do
      it "should loop through and assign groups" do
        start_group = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true)
        groups = PeerGroup.automatially_create_groups
        groups.each do |group|
          expect(group.length < 3).to be(false)
        end
        expect(groups.flatten.length).to eq(start_group.length)
        expect(groups.is_a?(Array)).to be(true)
      end
    end

    context "#create_groups" do
      it "Should loop through all the users for Tech and 1 and assign them all tp groups" do
        possible_peers = User.where(is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1)
        peer_groups = PeerGroup.create_groups([],"Technology", 1)
        expect(peer_groups.flatten.length).to eq(possible_peers.length)
      end
    end

    context "#reassign_not_full_groups" do
      it "Should loop through all the users for Tech and 1 and assign them all to groups if possible" do
        groups = PeerGroup.create_groups([],"Technology", 1)
        outlyers = PeerGroup.get_not_full_groups(groups)
        peer_groups = PeerGroup.reassign_not_full_groups(groups, outlyers)
        new_outlyers = PeerGroup.get_not_full_groups(peer_groups)
        expect(new_outlyers.length <= outlyers.length).to be(true)
      end
    end

    context "#get_not_full_groups" do
      it "Should return a array of the groups that were are not complete" do
        peer_groups = PeerGroup.get_not_full_groups([[1,2,3],[1,2],[1],[2,3,4]])
        expect(peer_groups.length).to eq(2)
        expect(peer_groups).to eq([[1,2],[1]])
      end
      it "Should return an empty array if nothing is found" do
        peer_groups = PeerGroup.get_not_full_groups([[1,2,3],[1,2,3],[1,3,4],[2,3,4]])
        expect(peer_groups.length).to eq(0)
        expect(peer_groups).to eq([])
      end
    end

    context "#assign_group_no_cg" do
      it "should assign peer based on interest and will assign if less than 3" do
        group1_1 = User.new(email: "908p8hpb9pgb@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
        group1_2 = User.new(email: "hello1234213@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
        group1_3 = User.new(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Cats","Beer"])
        group1 = [group1_1, group1_2, group1_3]
        group2 = [User.new(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "Cats","bats"])]
        group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Dogs").sample(2)
        peer = User.new(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Switching Industries", top_3_interests: ["Anime", "Cats","Fruit"])
        groups = [group1,group2,group3]
        new_groups = PeerGroup.assign_group_no_cg(groups, peer)
        expect(new_groups.length).to eq(3)
        expect(new_groups[0].length).to eq(3)
        expect(new_groups[1].length).to eq(2)
      end

      it "should assign peer based on interest" do
        group1_1 = User.new(email: "[09uj9p8-89]@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Bats"])
        group1_2 = User.new(email: "hel214234lo3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
        group1 = [group1_1, group1_2]
        group2 = [User.new(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "yoga","bats"])]
        group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Cats").sample(2)
        peer = User.new(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
        groups = [group1,group2,group3]
        new_groups = PeerGroup.assign_group_no_cg(groups, peer)
        expect(new_groups.length).to eq(3)
        expect(new_groups[0].length).to eq(3)
      end

      it "should create a new one if doesn't fit in any" do
        group1_1 = User.new(email: "[9hp97tg87]@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"])
        group1_2 = User.new(email: "hell2342o3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
        group1_3 = User.new(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"])
        group1 = [group1_1, group1_2, group1_3]
        group2 = [User.new(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "yoga","bats"])]
        group3 = User.where(current_goal: "Finding work/life balance").where("? = ANY(top_3_interests)", "Dogs").sample(2)
        peer = User.new(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
        groups = [group1,group2,group3]
        new_groups = PeerGroup.assign_group_no_cg(groups, peer)
        expect(new_groups[0].length).to eq(3)
        expect(new_groups[3].length).to eq(1)
      end
    end

    context "#assign_group_no_checks" do
      it 'should create groups if there is more than 4' do
        group = [[1,2,3],[1,2,3,4],[1,2,3]]
        group1_1 = User.new(email: "98pyho8y8h9@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"])
        group1_2 = User.new(email: "he234123llo3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
        group1_3 = User.new(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"])
        group1 = [group1_1, group1_2, group1_3]
        new_groups = PeerGroup.assign_group_no_checks(group, group1)
        expect(new_groups.length).to eq(4)
      end

      it 'should create groups if there is more than 4' do
        group = [[1,2,3],[1,2,3,4],[1,2,3]]
        group1_1 = User.new(email: "helyuog87glo2@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Hiking","Bats"])
        group1_2 = User.new(email: "hell13412433o3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Cats","Hiking"])
        group1_3 = User.new(email: "hello4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Frogs", "Hiking","Beer"])
        group1_4 = User.new(email: "hello563 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["puppies", "yoga","bats"])
        peer = User.new(email: "hello52343 @gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Anime", "Cats","Fruit"])
        group1 = [group1_1, group1_2, group1_3, group1_4, peer]
        new_groups = PeerGroup.assign_group_no_checks(group, group1)
        expect(new_groups.length).to eq(4)
        expect(new_groups[2].length).to eq(4)
        expect(new_groups[0].length).to eq(4)
        expect(new_groups[-1].length).to eq(3)
      end
    end

    context "#assign_to_group_of_three" do
      it "should assign a peer to a group of three" do
        group = PeerGroup.assign_to_group_of_three([[1,2,3],[1,2]], 5)
        expect(group[0].length).to eq(4)
        expect(group[0]).to eq([1,2,3,5])
      end

      it "should not assign the peer to a group of 4" do
        group = PeerGroup.assign_to_group_of_three([[1,2,3,4],[1,2]], 5)
        expect(group[0].length).to eq(4)
        expect(group[1]).to eq([1,2,5])
      end
    end

    context "#get_singles" do
      it "should get all groups with just one person in it" do
         group = [[1,2,3],[1],[1,2],[1,2,3],[1],[1],[1,2]]
         single_groups = PeerGroup.get_singles(group)
         expect(single_groups.length).to eq(3)
         expect(single_groups).to eq([[1],[1],[1]])
      end
    end

    context "#outlyers" do
      it "should send an email to someone if they can't be matched" do
        User.all.each do |user|
          user.update(is_participating_this_month: false)
        end
        group1_1 = User.create!(email: "987024234286@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", primary_industry: "Technology", stage_of_career: 2, current_goal: "Rising the ranks / breaking the glass ceiling", top_3_interests: ["Video Games", "Reading","Social issues / volunteering"])
        group1_2 = User.create!(email: "hello272033@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Beer","Video Games"], primary_industry: "Technology")
        group1_3 = User.create!(email: "hellq23r23o4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, primary_industry: "Technology", live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 3, current_goal: "Switching industries", top_3_interests: ["Music", "Cats","Beer"])
        group1_4 = User.create!(email: "987go243523486@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, primary_industry: "Technology", live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 5, current_goal: "Rising the ranks / breaking the glass ceiling", top_3_interests: ["Anime", "Dogs","Bats"])
        group1_5 = User.create!(email: "hell1341233o3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, primary_industry: "Technology", is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 2, current_goal: "Switching industries", top_3_interests: ["Mom", "Music","Hiking"])
        participants = User.where(is_participating_this_month:true, waitlist: false, live_in_detroit: true, is_assigned_peer_group:false)
        expect(participants.length).to eq(5)
        groups = PeerGroup.generate_groups
        new_participants = User.where(is_participating_this_month:true, waitlist: false, live_in_detroit: true, is_assigned_peer_group:false)
        expect(new_participants.length).to eq(0)
      end

    it "should make groups out of remainder if possible" do
      User.all.each do |user|
          user.update(is_participating_this_month: false)
        end
        group1_1 = User.create!(email: "987024234286@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", primary_industry: "Technology", stage_of_career: 2, current_goal: "Rising the ranks / breaking the glass ceiling", top_3_interests: ["Video Games", "Reading","Social issues / volunteering"])
        group1_2 = User.create!(email: "hello23@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Technology", stage_of_career: 1, current_goal: "Finding work/life balance", top_3_interests: ["Mom", "Beer","Video Games"], primary_industry: "Technology")
        group1_3 = User.create!(email: "hellq23o4@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, primary_industry: "Technology", live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Startup", stage_of_career: 3, current_goal: "Switching industries", top_3_interests: ["Music", "Cats","Beer"])
        group1_4 = User.create!(email: "987go243486@gmail.com", password_confirmation: "Howearesese12", first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, primary_industry: "Technology", live_in_detroit: true, is_assigned_peer_group: false, peer_industry: "Startup", stage_of_career: 5, current_goal: "Rising the ranks / breaking the glass ceiling", top_3_interests: ["Anime", "Dogs","Bats"])
        group1_5 = User.create!(email: "hello1333o3@gmail.com", password_confirmation: "Howearesese12",  first_name: "John", last_name: "Smith", is_participating_this_month: true, waitlist: false, live_in_detroit: true, primary_industry: "Technology", is_assigned_peer_group: false, peer_industry: "Business", stage_of_career: 2, current_goal: "Switching industries", top_3_interests: ["Mom", "Music","Hiking"])
        participants = User.where(is_participating_this_month:true, waitlist: false, live_in_detroit: true, is_assigned_peer_group:false)
        expect(participants.length).to eq(5)
        groups = PeerGroup.generate_groups
        new_participants = User.where(is_participating_this_month:true, waitlist: false, live_in_detroit: true, is_assigned_peer_group:false)
        expect(new_participants.length).to eq(0)
      end
    end
  end
end
