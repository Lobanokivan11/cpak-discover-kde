import subprocess
import sys

PATCH_CONTENT = """diff --git a/libdiscover/backends/CMakeLists.txt b/libdiscover/backends/CMakeLists.txt
index 18f7c6de3..2af94c126 100644
--- a/libdiscover/backends/CMakeLists.txt
+++ b/libdiscover/backends/CMakeLists.txt
@@ -102,3 +102,8 @@ option(BUILD_AlpineApkBackend "Build Alpine APK support." "ON")
 if(BUILD_AlpineApkBackend AND ApkQt_FOUND)
     add_subdirectory(AlpineApkBackend)
 endif()
+
+option(BUILD_CpakBackend "Build Cpak support." "ON")
+if(BUILD_CpakBackend)
+    add_subdirectory(CpakBackend)
+endif()
"""


def apply_patch():
    try:
        # Use `patch -p1` if running outside of a .git directory
        process = subprocess.run(
            ["git", "apply", "--ignore-whitespace", "-"],
            input=PATCH_CONTENT,
            text=True,
            capture_output=True,
            check=True,
        )
        print("Patch applied successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to apply patch:\n{e.stderr}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    apply_patch()
