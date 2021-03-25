package data
{
    import spark.collections.Sort;
    import spark.collections.SortField;

    public class ProjectSort
    {
        public static function get byName():Sort
        {
            var sort:Sort = new Sort();
            sort.fields = [new SortField("name", false)];
            return sort;
        }

        public static function get byCreated():Sort
        {
            var sort:Sort = new Sort();
            sort.fields = [new SortField("dateCreated", true)];
            return sort;
        }

        public static function get byModified():Sort
        {
            var sort:Sort = new Sort();
            sort.fields = [new SortField("dateModified", true)];
            return sort;
        }
    }
}
