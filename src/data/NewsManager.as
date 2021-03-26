package data
{
    import flash.events.EventDispatcher;

    public class NewsManager extends EventDispatcher
    {
        private static var _instance:NewsManager;

        public var news:Array;

        public function NewsManager()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;
        }

        public function load(arr:Array):void
        {
            news = [];
            for each (var u:Object in arr)
            {
                var newsData:NewsData = new NewsData();
                newsData.title = u.title;
                newsData.date = u.date;
                newsData.content = [];

                for each (var v:Object in u.content)
                {
                    var section:NewsSectionData = new NewsSectionData();
                    section.type = v.type;
                    section.text = v.text;
                    section.url = v.url;

                    newsData.content.push(section);
                }

                news.push(newsData);
            }
        }

        public static function get instance():NewsManager
        {
            if (!_instance)
                new NewsManager();
            return _instance;
        }
    }
}