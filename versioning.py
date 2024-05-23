import semver
import subprocess

def get_current_version():
    try:
        current_tag = subprocess.check_output(['git', 'describe', '--tags']).decode().strip()
        return semver.Version.parse(current_tag)  # return the current tag
    except subprocess.CalledProcessError:
        return semver.Version.parse('0.1.0')  # if there are no tags, return a default version
    
def update_version(version, part):
    if part == 'minor':
        new_version = version.bump_minor()
    else:
        new_version = version

    return new_version

def main():
    current_version = get_current_version()
    new_version = update_version(current_version, part='minor')
    
    print(new_version)

if __name__ == "__main__":
    main()
