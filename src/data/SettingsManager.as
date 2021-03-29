package data
{
    import flash.events.EventDispatcher;
    import flash.net.SharedObject;

    public class SettingsManager extends EventDispatcher
    {
        private static var _instance:SettingsManager;

        private static var shared:SharedObject;
        private static var defaultProperties:Object = {firstRunPopup: true};

        public function SettingsManager()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;

            shared = SharedObject.getLocal("properties");
            if (!shared.data.properties)
                setDefaults();
        }

        public function setDefaults():void
        {
            shared.data.properties = defaultProperties;
            shared = SharedObject.getLocal("properties");
        }

        public function setProperty(key:String, data:Object):void
        {
            shared.data.properties[key] = data;
        }

        public function getProperty(key:String):Object
        {
            return shared.data.properties[key];
        }

        public static function get instance():SettingsManager
        {
            if (!_instance)
                new SettingsManager();
            return _instance;
        }
    }
}