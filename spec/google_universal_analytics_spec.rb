require 'google_universal_analytics'

class DummyClass
  include GoogleUniversalAnalytics
end

describe GoogleUniversalAnalytics do
  let(:dummy_object) { DummyClass.new }

  let(:basic_options) do
    {
      tracker: 'UA-TEST',
      domain: 'test.net'
    }
  end

  let (:custom_vars) do
    [
      { index: 2, value: 'cheese' },
      { index: 5, value: 'cats' }
    ]
  end

  let (:events) do
    [
      { category: 'button', action: 'press', label: 'cheese', value: 'on'},
      { category: 'widget', action: 'twiddle', label: 'cats', value: 'off'}
    ]
  end

  describe 'custom variables' do
    context 'single custom variable' do
      let(:custom_var) do
        { index: 2, value: 'cheese' }
      end

      it 'should produce the right jscript' do
        expect(dummy_object.custom_var_jscript(custom_var)).to eq("ga('set', 'dimension2', 'cheese');")
      end
    end

    context 'multiple custom variables' do
      it 'should pruduct the right jscript' do
        expect(dummy_object.custom_vars_jscript(custom_vars)).to eq("ga('set', 'dimension2', 'cheese');\nga('set', 'dimension5', 'cats');")
      end
    end
  end

  describe 'event tracking' do
    context 'single event' do
      let (:event) do
        { category: 'button', action: 'press', label: 'cheese', value: 'on'}
      end

      it 'should product the right jscript' do
        expect(dummy_object.track_event_jscript(event)).to eq("ga('send', 'event', 'button', 'press', 'cheese', 'on');")
      end
    end

    context 'multiple events' do
      it 'should product the right jscript' do
        expect(dummy_object.track_events_jscript(events)).to eq("ga('send', 'event', 'button', 'press', 'cheese', 'on');\nga('send', 'event', 'widget', 'twiddle', 'cats', 'off');")
      end
    end
  end

  describe 'analytics.js function call' do
    context 'google_universal_analytics_init called with options including domain' do
      let (:options) do
        basic_options.merge({
          custom_vars: custom_vars,
          events: events
        })
      end

      it 'should produce the proper script' do
        expect(dummy_object.google_universal_analytics_init(options)).to eq (
          "<script>\n" +
          "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){\n" +
          "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n" +
          "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n" +
          "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');\n" +
          "ga('create', 'UA-TEST', { cookieDomain: 'test.net' });\n" +
          "ga('set', 'dimension2', 'cheese');\nga('set', 'dimension5', 'cats');\n" +
          "ga('send', 'event', 'button', 'press', 'cheese', 'on');\nga('send', 'event', 'widget', 'twiddle', 'cats', 'off');\n" +
          "ga('send', 'pageview');\n" +
          "</script>\n"
        )
      end
    end

    context 'google_universal_analytics_init called with options without domain' do
      let (:options) do
        basic_options.merge({
          custom_vars: custom_vars,
          events: events
        }).tap { |obj| obj.delete(:domain) }
      end

      it 'should produce the proper script' do
        expect(dummy_object.google_universal_analytics_init(options)).to eq (
          "<script>\n" +
          "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){\n" +
          "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n" +
          "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n" +
          "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');\n" +
          "ga('create', 'UA-TEST');\n" +
          "ga('set', 'dimension2', 'cheese');\nga('set', 'dimension5', 'cats');\n" +
          "ga('send', 'event', 'button', 'press', 'cheese', 'on');\nga('send', 'event', 'widget', 'twiddle', 'cats', 'off');\n" +
          "ga('send', 'pageview');\n" +
          "</script>\n"
        )
      end
    end
  end
end
