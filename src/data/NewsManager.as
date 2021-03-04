package data
{
    import flash.events.EventDispatcher;

    public class NewsManager extends EventDispatcher
    {
        private static var _instance:NewsManager;

        public function NewsManager()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;
        }

        public static function get instance():NewsManager
        {
            if (!_instance)
                new NewsManager();
            return _instance;
        }
    }
}