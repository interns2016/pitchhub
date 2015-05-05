require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

module WithinHelpers
  def with_scope(locator)
    if locator
      within(locator, match: :first) do
        yield
      end
    else
      yield
    end
  end
end
World(WithinHelpers)


Given /^(?:|I )am on (.+)$/ do |page_name|
  navigate_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  navigate_to(page_name)
end

When /^(?:|I )press "([^"]*)"(?: within "([^"]*)")?$/ do |button, selector|
  with_scope(selector) do
    click_button(button)
  end
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"(?: within "([^"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end
When /^(?:|I )fill in "([^"]*)" for "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

When /^(?:|I )fill in the following(?: within "([^"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      step %{I fill in "#{name}" with "#{value}"}
    end
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    select(value, :from => field)
  end
end
When /^(?:|I )check "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    check(field)
  end
end
When /^(?:|I )uncheck "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    uncheck(field)
  end
end
When /^(?:|I )choose "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    choose(field)
  end
end
When /^(?:|I )attach the file "([^"]*)" to (?:hidden )?"([^"]*)"(?: within "([^"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    page.execute_script("$(\"input[name='#{field}']\").css('opacity', '1');")
    attach_file(field, Rails.root.join(path).to_s)
  end
end

Then /^(?:|I )should see JSON:$/ do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(response.body))
  expected.should == actual
end

Then /^(?:|I )should see (\".+?\"[\s]*)(?:[\s]+within[\s]* "([^"]*)")?$/ do |vars, selector|
  vars.scan(/"([^"]+?)"/).flatten.each do |text|
    with_scope(selector) do
      current_scope.should have_text(text)
    end
  end
end

Then /^(?:|I )should see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    page.should have_xpath('//*', :text => regexp)
  end
end
Then /^(?:|I )should not see (\".+?\"[\s]*)(?:[\s]+within[\s]* "([^"]*)")?$/ do |vars,selector|
  vars.scan(/"([^"]+?)"/).flatten.each do |text|
    with_scope(selector) do
      page.should has_no_text?(text)
    end
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    page.should has_no_xpath?('//*', :text => regexp)
  end
end
Then /^the "([^"]*)" field(?: within "([^"]*)")? should contain "([^"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    field_value.should =~ /#{value}/
  end
end

Then /^the "([^"]*)" field(?: within "([^"]*)")? should not contain "([^"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    field_value.should_not =~ /#{value}/
  end
end
Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    field_checked.should eq('true')
  end
end
Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should not be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    field_checked.should be_falsey
  end
end
Then /^(?:|I )should be on (.+)$/ do |page_name|
  confirm_on_page(page_name)
end
Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')}
  actual_params.should == expected_params
end
Then /^show me the page$/ do
  save_and_open_page
end

When /^(?:|I )follow "([^"]*)"(?: within "([^"]*)")?$/ do |link, selector|
  with_scope(selector) do
    click_link(link)
  end
end