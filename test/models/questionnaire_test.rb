require 'test_helper'

class QuestionnaireTest < ActiveSupport::TestCase

  should belong_to :school

  should strip_attribute :first_name
  should strip_attribute :last_name
  should strip_attribute :acc_status
  should strip_attribute :major
  should strip_attribute :gender
  should strip_attribute :dietary_restrictions
  should strip_attribute :special_needs
  should strip_attribute :travel_location

  should validate_presence_of :first_name
  should validate_presence_of :last_name
  should validate_presence_of :date_of_birth
  should validate_presence_of :experience
  should validate_presence_of :shirt_size
  should validate_presence_of :phone
  should validate_presence_of :graduation
  should validate_presence_of :major
  should validate_presence_of :gender
  should_not validate_presence_of :dietary_restrictions
  should_not validate_presence_of :special_needs
  should_not validate_presence_of :resume
  should_not validate_presence_of :international
  should_not validate_presence_of :portfolio_url
  should_not validate_presence_of :vcs_url
  should_not validate_presence_of :acc_status
  should_not validate_presence_of :acc_status_author_id
  should_not validate_presence_of :acc_status_date
  should_not validate_presence_of :riding_bus
  should_not validate_presence_of :can_share_info
  should_not validate_presence_of :travel_not_from_school
  should_not validate_presence_of :travel_location

  should allow_mass_assignment_of :first_name
  should allow_mass_assignment_of :last_name
  should allow_mass_assignment_of :date_of_birth
  should allow_mass_assignment_of :experience
  should allow_mass_assignment_of :graduation
  should allow_mass_assignment_of :major
  should allow_mass_assignment_of :gender
  should allow_mass_assignment_of :school_id
  should allow_mass_assignment_of :school_name
  should allow_mass_assignment_of :shirt_size
  should allow_mass_assignment_of :dietary_restrictions
  should allow_mass_assignment_of :special_needs
  should allow_mass_assignment_of :resume
  should allow_mass_assignment_of :delete_resume
  should allow_mass_assignment_of :international
  should allow_mass_assignment_of :portfolio_url
  should allow_mass_assignment_of :vcs_url
  should allow_mass_assignment_of :agreement_accepted
  should allow_mass_assignment_of :bus_captain_interest
  should allow_mass_assignment_of :riding_bus
  should allow_mass_assignment_of :phone
  should allow_mass_assignment_of :can_share_info
  should allow_mass_assignment_of :code_of_conduct_accepted
  should allow_mass_assignment_of :travel_not_from_school
  should allow_mass_assignment_of :travel_location
  should_not allow_mass_assignment_of :checked_in_by
  should_not allow_mass_assignment_of :checked_in_at
  should_not allow_mass_assignment_of :acc_status
  should_not allow_mass_assignment_of :acc_status_author_id
  should_not allow_mass_assignment_of :acc_status_date
  should_not allow_mass_assignment_of :is_bus_captain

  should allow_value("first").for(:experience)
  should allow_value("experienced").for(:experience)
  should allow_value("expert").for(:experience)
  should_not allow_value("foo").for(:experience)

  should allow_value("Women's - XS").for(:shirt_size)
  should allow_value("Women's - S").for(:shirt_size)
  should allow_value("Women's - M").for(:shirt_size)
  should allow_value("Women's - L").for(:shirt_size)
  should allow_value("Women's - XL").for(:shirt_size)
  should allow_value("Unisex - XS").for(:shirt_size)
  should allow_value("Unisex - S").for(:shirt_size)
  should allow_value("Unisex - M").for(:shirt_size)
  should allow_value("Unisex - L").for(:shirt_size)
  should allow_value("Unisex - XL").for(:shirt_size)
  should_not allow_value("M").for(:shirt_size)
  should_not allow_value("foo").for(:shirt_size)

  should allow_value(true).for(:agreement_accepted)
  should_not allow_value(false).for(:agreement_accepted)
  should allow_value(true).for(:code_of_conduct_accepted)
  should_not allow_value(false).for(:code_of_conduct_accepted)

  should allow_value("pending").for(:acc_status)
  should allow_value("accepted").for(:acc_status)
  should allow_value("waitlist").for(:acc_status)
  should allow_value("denied").for(:acc_status)
  should allow_value("late_waitlist").for(:acc_status)
  should allow_value("rsvp_confirmed").for(:acc_status)
  should allow_value("rsvp_denied").for(:acc_status)
  should_not allow_value("foo").for(:acc_status)

  should have_attached_file(:resume)
  should validate_attachment_content_type(:resume)
                .allowing('application/pdf')
                .rejecting('text/plain', 'image/png', 'image/jpg', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
  should validate_attachment_size(:resume).less_than(2.megabytes)

  should "allow deletion of attachment via method" do
    questionnaire = create(:questionnaire)
    questionnaire.resume = sample_file()
    assert_equal "sample_pdf.pdf", questionnaire.resume_file_name
    questionnaire.delete_resume = "1"
    questionnaire.save
    assert_equal false, questionnaire.resume?
    assert_nil questionnaire.resume_file_name
  end

  should allow_value('foo.com').for(:portfolio_url)
  should allow_value('github.com/foo', 'bitbucket.org/sman591').for(:vcs_url)
  should allow_value('https://github.com/foo', 'https://bitbucket.org/sman591').for(:vcs_url)
  should_not allow_value('http://foo.com', 'https://bar.com').for(:vcs_url)

  context "#school" do
    should "return nil if no school set" do
      questionnaire = create(:questionnaire)
      questionnaire.update_attribute(:school_id, nil)
      assert_nil questionnaire.school
    end

    should "return the current school" do
      school = create(:school, name: "My University")
      questionnaire = create(:questionnaire, school_id: school.id)
      assert_equal "My University", questionnaire.school.name
    end

    should "increment school questionnaire counter on create" do
      school = create(:school)
      questionnaire = create(:questionnaire, school_id: school.id)
      assert_equal 1, school.reload.questionnaire_count
    end

    should "update school questionnaire counters on update" do
      school1 = create(:school, name: "School 1")
      school2 = create(:school, name: "School 2", id: 2)
      questionnaire = create(:questionnaire, school_id: school1.reload.id)
      questionnaire.school_id = school2.id
      questionnaire.save
      assert_equal 0, school1.reload.questionnaire_count
      assert_equal 1, school2.reload.questionnaire_count
    end

    should "decrement school questionnaire counter on destroy" do
      school = create(:school)
      questionnaire = create(:questionnaire, school_id: school.id)
      assert_equal 1, school.reload.questionnaire_count
      questionnaire.destroy
      assert_equal 0, school.reload.questionnaire_count
    end
  end

  context "#full_name" do
    should "concatenate first and last name" do
      questionnaire = create(:questionnaire, first_name: "Foo", last_name: "Bar")
      assert_equal "Foo Bar", questionnaire.full_name
    end
  end

  context "#full_location" do
    should "concatenate city and state with a comma" do
      school = create(:school, city: "Foo", state: "AZ")
      questionnaire = create(:questionnaire, school_id: school.id)
      assert_equal "Foo, AZ", questionnaire.full_location
    end
  end

  context "#date_of_birth_formatted" do
    should "format date_of_birth correctly" do
      questionnaire = create(:questionnaire, date_of_birth: Date.new(1995, 1, 5))
      assert_equal "January 5, 1995", questionnaire.date_of_birth_formatted
    end
  end

  context "#email" do
    should "return the questionnaire's user" do
      questionnaire = create(:questionnaire)
      questionnaire.user.email = "joe.smith@example.com"
      assert_equal "joe.smith@example.com", questionnaire.email
    end
  end

  context "#acc_status_author" do
    should "return nil if no author" do
      questionnaire = create(:questionnaire, acc_status_author_id: nil)
      assert_equal nil, questionnaire.acc_status_author
    end

    should "return the questionnaire's user" do
      user = create(:user, email: "admin@example.com")
      questionnaire = create(:questionnaire, acc_status_author_id: user.id)
      assert_equal "admin@example.com", questionnaire.acc_status_author.email
    end
  end

  context "#can_rsvp?" do
    should "return true for accepted questionnaires" do
      questionnaire = create(:questionnaire, acc_status: "accepted")
      assert questionnaire.can_rsvp?
      questionnaire.acc_status = "rsvp_confirmed"
      assert questionnaire.can_rsvp?
      questionnaire.acc_status = "rsvp_denied"
      assert questionnaire.can_rsvp?
    end

    should "return false for non-accepted questionnaires" do
      questionnaire = create(:questionnaire, acc_status: "denied")
      assert !questionnaire.can_rsvp?
    end
  end

  context "#did_rsvp?" do
    should "return true for confirmed & denied questionnaires" do
      questionnaire = create(:questionnaire)
      ['rsvp_confirmed', 'rsvp_denied'].each do |status|
        questionnaire.acc_status = status
        assert questionnaire.did_rsvp?
      end
    end

    should "return false for non-RSVP'd questionnaires" do
      questionnaire = create(:questionnaire)
      ['pending', 'accepted', 'denied', 'waitlist', 'late_waitlist'].each do |status|
        questionnaire.acc_status = status
        assert !questionnaire.did_rsvp?
      end
    end
  end

  context "#can_ride_bus?" do
    should "return false if no school set" do
      questionnaire = create(:questionnaire)
      questionnaire.update_attribute(:school_id, nil)
      assert_equal false, questionnaire.can_ride_bus?
    end

    should "return false if school does not have bus" do
      questionnaire = create(:questionnaire)
      questionnaire.school.update_attribute(:bus_list_id, nil)
      assert_equal false, questionnaire.can_ride_bus?
    end

    should "return true if school has a bus" do
      questionnaire = create(:questionnaire)
      bus_list = create(:bus_list)
      questionnaire.school.update_attribute(:bus_list_id, bus_list.id)
      assert_equal true, questionnaire.can_ride_bus?
    end
  end

  context "#checked_in_by" do
    should "return no one if not checked in" do
      questionnaire = create(:questionnaire)
      assert_nil questionnaire.checked_in_by
      assert_nil questionnaire.checked_in_by_id
    end

    should "return user who checked in ther questionnaire" do
      user = create(:user)
      questionnaire = create(:questionnaire, checked_in_by_id: user.id)
      assert_equal user.id, questionnaire.checked_in_by.id
      assert_equal user.id, questionnaire.checked_in_by_id
    end
  end

  context "#fips_code" do
    should "return fips code" do
      school = create(:school, city: "Rochester", state: "NY")
      create(:fips, fips_code: "36055", city: "Rochester", state: "NY")
      questionnaire = create(:questionnaire, school: school)
      assert_equal "36055", questionnaire.fips_code.fips_code
    end

    should "return null if no fips code" do
      school = create(:school, city: "Not Found", state: "NF")
      create(:fips, fips_code: "36055", city: "Rochester", state: "NY")
      questionnaire = create(:questionnaire, school: school)
      assert_nil questionnaire.fips_code
    end
  end

end
