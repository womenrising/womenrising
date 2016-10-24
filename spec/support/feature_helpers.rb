module FeatureHelpers

  def visit_and_confirm(path)
    visit path
    expect(page.current_path).to eq(path)
    expect(page.status_code).to eq(200)
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end



  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

end
