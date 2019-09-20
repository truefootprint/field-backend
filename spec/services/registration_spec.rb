RSpec.describe Registration do
  let(:user) { FactoryBot.create(:user) }
  let(:viewpoint) { Viewpoint.new(user: user) }

  let(:project) { FactoryBot.create(:project) }

  it "grants visibility of the subject" do
    expect { described_class.process(viewpoint: viewpoint, subject: project) }
      .to change(Visibility, :count).by(1)

    visibility = Visibility.last

    expect(visibility.subject).to eq(project)
    expect(visibility.visible_to).to eq(user)
  end

  it "raises an error if the viewpoint has no user" do
    viewpoint = Viewpoint.new(role: FactoryBot.create(:role))

    expect { described_class.process(viewpoint: viewpoint, subject: project) }
      .to raise_error(RegistrationError, /must be on behalf of a user/)
  end

  context "when the viewpoint also specifies a role" do
    let(:role) { FactoryBot.create(:role) }
    let(:viewpoint) { Viewpoint.new(user: user, role: role) }

    let!(:user_role) { FactoryBot.create(:user_role, user: user, role: role) }

    it "grants visibility to the user_role instead of the user" do
      expect { described_class.process(viewpoint: viewpoint, subject: project) }
        .to change(Visibility, :count).by(1)

      expect(Visibility.last.visible_to).to eq(user_role)
    end

    it "creates the user_role if it doesn't exist" do
      user_role.destroy

      expect { described_class.process(viewpoint: viewpoint, subject: project) }
        .to change(UserRole, :count).by(1)
    end
  end

  context "when the subject has registration actions" do
    let(:project_activity) { FactoryBot.create(:project_activity) }

    it "runs the registration actions" do
      expect(Registration::ProjectActivityActions).to receive(:run)
        .with(project_activity, viewpoint)

      described_class.process(viewpoint: viewpoint, subject: project_activity)
    end
  end
end
