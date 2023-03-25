#include "Filesystem_File.h"

namespace Q
{
File::File(const std::filesystem::path&& path, QIODeviceBase::OpenModeFlag openMode) : _file(QString::fromStdWString(path.generic_wstring()))
{
	_file.open(QIODeviceBase::OpenMode(openMode))
}
} // namespace Q