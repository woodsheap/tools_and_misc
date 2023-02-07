:: SPDX-FileCopyrightText: 2023 Brian Woods
:: SPDX-License-Identifier: GPL-2.0-or-later

C:\

set LSTN_PORT=18181
set FFMPEG_PATH=C:\Users\user\ffmpeg-master-latest-win64-gpl\bin

cd %FFMPEG_PATH%

ffplay.exe -nodisp rtp://0.0.0.0:%LSTN_PORT%

exit
