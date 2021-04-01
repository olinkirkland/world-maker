package data
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.filesystem.File;

    public class EngineManager extends EventDispatcher
    {
        private static var _instance:EngineManager;

        public static const ENGINES_CHANGED:String = "enginesChanged";

        public var engines:Array;

        public function EngineManager()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;
        }

        public function enginesChanged():void
        {
            dispatchEvent(new Event(ENGINES_CHANGED));
        }

        public function hasAnyEnginesInstalled():Boolean
        {
            for each (var engine:EngineData in engines)
                if (engine.installDirectory.exists)
                    return true;

            return false;
        }

        public function load(arr:Array):void
        {
            var folder:File = File.applicationStorageDirectory.resolvePath("versions");
            if (!folder.exists)
                folder.createDirectory();

            engines = [];
            for each (var u:Object in arr)
            {
                var engineData:EngineData = new EngineData();
                engineData.version = u.version;
                engineData.url = u.url;
                engineData.date = u.date;
                engineData.installDirectory = folder.resolvePath(engineData.version);

                engines.push(engineData);
            }
        }

        public static function get instance():EngineManager
        {
            if (!_instance)
                new EngineManager();
            return _instance;
        }

        public function getEngineByVersion(engine:String):EngineData
        {
            for each (var engineData:EngineData in engines)
                if (engine == engineData.version)
                    return engineData;

            return null;
        }
    }
}