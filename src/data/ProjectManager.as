package data
{
    import flash.display.Screen;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;

    import mx.collections.ArrayCollection;

    import ui.ProjectWindow;

    public class ProjectManager extends EventDispatcher
    {
        private static var _instance:ProjectManager;

        public static const PROJECTS_CHANGED:String = "projectsChanged";

        public var projects:ArrayCollection;

        public function ProjectManager()
        {
            if (_instance)
                throw new Error("Singletons can only have one instance");
            _instance = this;

            load();
        }

        public function projectsChanged():void
        {
            dispatchEvent(new Event(PROJECTS_CHANGED));
        }

        public function validateNewName(value:String):Boolean
        {
            var valid:Boolean = true;
            for each (var p:ProjectData in ProjectManager.instance.projects)
            {
                if (p.name == value)
                    valid = false;
            }

            return valid;
        }

        public function load():void
        {
            // Reads projects from files in projects directory
            var folder:File = File.applicationStorageDirectory.resolvePath("projects");
            if (!folder.exists)
                folder.createDirectory();

            projects = new ArrayCollection();
            var arr:Array = folder.getDirectoryListing();
            for each (var file:File in arr)
            {
                var fileStream:FileStream = new FileStream();
                fileStream.open(file, FileMode.READ);
                var u:Object = JSON.parse(fileStream.readUTFBytes(fileStream.bytesAvailable));
                fileStream.close();

                var projectData:ProjectData = new ProjectData();
                projectData.file = file;
                projectData.name = u.meta.name;
                projectData.date = u.meta.date;
                projectData.engine = u.meta.engine;
                projects.addItem(projectData);
            }
        }

        public function launch(projectData:ProjectData):void
        {
            // Opens a new window in fullscreen with the version's swf

            var window:ProjectWindow = new ProjectWindow();
            window.open(true);
            var screen:Screen = Screen.mainScreen;

            if (false)
            {
                // todo Apply Saved Size
            }

            window.x = screen.bounds.x;
            window.y = screen.bounds.y;
            window.width = screen.bounds.width;
            window.height = screen.bounds.height;
            window.maximize();

            // Load project swf
            var swfFile:File = EngineManager.instance.getEngineByVersion(projectData.engine).installDirectory.resolvePath("Main.swf");
            var fileStream:FileStream = new FileStream();
            fileStream.open(swfFile, FileMode.READ);

            var swfBytes:ByteArray = new ByteArray();
            fileStream.readBytes(swfBytes);
            fileStream.close();

            window.start(swfBytes, projectData);

//            swfLoader.loaderContext = context;
//            swfLoader.source = swfBytes;
//            swfLoader.load();
//
//            splash.visible = false;
//
//            swfLoader.addEventListener(Event.COMPLETE, function (event:Event):void
//            {
//                try
//                {
//                    width = swfLoader.content["measuredWidth"];
//                    height = swfLoader.content["measuredHeight"];
//                } catch (error:Error)
//                {
//                    // No dimensions in loader
//                }
//
//                center();
//            });
        }

        public function saveAll():void
        {
            for each (var projectData:ProjectData in projects)
                projectData.save();
        }

        public static function get instance():ProjectManager
        {
            if (!_instance)
                new ProjectManager();
            return _instance;
        }

        public function addProject(projectData:ProjectData):void
        {
            projects.addItem(projectData);
            projectData.save();
        }
    }
}