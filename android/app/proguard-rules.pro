# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# SQLite rules
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# Provider rules
-keep class * extends androidx.lifecycle.ViewModel { *; }
-keep class * extends androidx.lifecycle.AndroidViewModel { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep R classes
-keep class **.R$* {
    public static <fields>;
}

# Keep custom application classes
-keep class com.example.taskwise.** { *; }

# Keep database helper classes
-keep class * extends android.database.sqlite.SQLiteOpenHelper { *; }

# Keep model classes
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions

# Keep generic signatures
-keepattributes Signature

# Keep source file names for better stack traces
-keepattributes SourceFile,LineNumberTable

# Keep inner classes
-keep class * {
    public class * {
        public *;
    }
}

# Keep public methods
-keep public class * {
    public <methods>;
}

# Keep public fields
-keep public class * {
    public <fields>;
}

# Keep public constructors
-keep public class * {
    public <init>(...);
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep JavaScript interface methods
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep WebView JavaScript interface
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep custom exceptions
-keep public class * extends java.lang.Exception

# Keep custom errors
-keep public class * extends java.lang.Error

# Keep custom runtime exceptions
-keep public class * extends java.lang.RuntimeException

# Keep custom checked exceptions
-keep public class * extends java.lang.Exception

# Keep custom unchecked exceptions
-keep public class * extends java.lang.RuntimeException

# Keep custom throwable
-keep public class * extends java.lang.Throwable

# Keep custom serializable
-keep public class * implements java.io.Serializable

# Keep custom cloneable
-keep public class * implements java.lang.Cloneable

# Keep custom comparable
-keep public class * implements java.lang.Comparable

# Keep custom iterable
-keep public class * implements java.lang.Iterable

# Keep custom collection
-keep public class * implements java.util.Collection

# Keep custom list
-keep public class * implements java.util.List

# Keep custom set
-keep public class * implements java.util.Set

# Keep custom map
-keep public class * implements java.util.Map

# Keep custom iterator
-keep public class * implements java.util.Iterator

# Keep custom list iterator
-keep public class * implements java.util.ListIterator

# Keep custom enumeration
-keep public class * implements java.util.Enumeration

# Keep custom comparator
-keep public class * implements java.util.Comparator

# Keep custom observer
-keep public class * implements java.util.Observer

# Keep custom observable
-keep public class * extends java.util.Observable

# Keep custom event listener
-keep public class * implements java.util.EventListener

# Keep custom event object
-keep public class * extends java.util.EventObject

# Keep custom timer task
-keep public class * extends java.util.TimerTask

# Keep custom random access
-keep public class * implements java.util.RandomAccess

# Keep custom queue
-keep public class * implements java.util.Queue

# Keep custom deque
-keep public class * implements java.util.Deque

# Keep custom navigable set
-keep public class * implements java.util.NavigableSet

# Keep custom navigable map
-keep public class * implements java.util.NavigableMap

# Keep custom sorted set
-keep public class * implements java.util.SortedSet

# Keep custom sorted map
-keep public class * implements java.util.SortedMap

# Keep custom blocking queue
-keep public class * implements java.util.concurrent.BlockingQueue

# Keep custom blocking deque
-keep public class * implements java.util.concurrent.BlockingDeque

# Keep custom callable
-keep public class * implements java.util.concurrent.Callable

# Keep custom future
-keep public class * implements java.util.concurrent.Future

# Keep custom executor
-keep public class * implements java.util.concurrent.Executor

# Keep custom executor service
-keep public class * implements java.util.concurrent.ExecutorService

# Keep custom scheduled executor service
-keep public class * implements java.util.concurrent.ScheduledExecutorService

# Keep custom thread factory
-keep public class * implements java.util.concurrent.ThreadFactory

# Keep custom reject execution handler
-keep public class * implements java.util.concurrent.RejectedExecutionHandler

# Keep custom completion service
-keep public class * implements java.util.concurrent.CompletionService

# Keep custom scheduled future
-keep public class * implements java.util.concurrent.ScheduledFuture

# Keep custom delayed
-keep public class * implements java.util.concurrent.Delayed

# Keep custom transfer queue
-keep public class * implements java.util.concurrent.TransferQueue

# Keep custom concurrent map
-keep public class * implements java.util.concurrent.ConcurrentMap

# Keep custom concurrent navigable map
-keep public class * implements java.util.concurrent.ConcurrentNavigableMap

# Keep custom concurrent skip list set
-keep public class * implements java.util.concurrent.ConcurrentSkipListSet

# Keep custom concurrent skip list map
-keep public class * implements java.util.concurrent.ConcurrentSkipListMap

# Keep custom concurrent hash map
-keep public class * implements java.util.concurrent.ConcurrentHashMap

# Keep custom concurrent linked queue
-keep public class * implements java.util.concurrent.ConcurrentLinkedQueue

# Keep custom concurrent linked deque
-keep public class * implements java.util.concurrent.ConcurrentLinkedDeque

# Keep custom array blocking queue
-keep public class * implements java.util.concurrent.ArrayBlockingQueue

# Keep custom linked blocking queue
-keep public class * implements java.util.concurrent.LinkedBlockingQueue

# Keep custom linked blocking deque
-keep public class * implements java.util.concurrent.LinkedBlockingDeque

# Keep custom priority blocking queue
-keep public class * implements java.util.concurrent.PriorityBlockingQueue

# Keep custom synchronous queue
-keep public class * implements java.util.concurrent.SynchronousQueue

# Keep custom delay queue
-keep public class * implements java.util.concurrent.DelayQueue

# Keep custom transfer queue
-keep public class * implements java.util.concurrent.TransferQueue

# Keep custom linked transfer queue
-keep public class * implements java.util.concurrent.LinkedTransferQueue

# Keep custom priority queue
-keep public class * implements java.util.PriorityQueue

# Keep custom concurrent hash map
-keep public class * implements java.util.concurrent.ConcurrentHashMap

# Keep custom concurrent skip list map
-keep public class * implements java.util.concurrent.ConcurrentSkipListMap

# Keep custom concurrent skip list set
-keep public class * implements java.util.concurrent.ConcurrentSkipListSet

# Keep custom concurrent linked queue
-keep public class * implements java.util.concurrent.ConcurrentLinkedQueue

# Keep custom concurrent linked deque
-keep public class * implements java.util.concurrent.ConcurrentLinkedDeque

# Keep custom array blocking queue
-keep public class * implements java.util.concurrent.ArrayBlockingQueue

# Keep custom linked blocking queue
-keep public class * implements java.util.concurrent.LinkedBlockingQueue

# Keep custom linked blocking deque
-keep public class * implements java.util.concurrent.LinkedBlockingDeque

# Keep custom priority blocking queue
-keep public class * implements java.util.concurrent.PriorityBlockingQueue

# Keep custom synchronous queue
-keep public class * implements java.util.concurrent.SynchronousQueue

# Keep custom delay queue
-keep public class * implements java.util.concurrent.DelayQueue

# Keep custom transfer queue
-keep public class * implements java.util.concurrent.TransferQueue

# Keep custom linked transfer queue
-keep public class * implements java.util.concurrent.LinkedTransferQueue

# Keep custom priority queue
-keep public class * implements java.util.PriorityQueue 