const fs = require('fs');

if (process.argv.length != 3) {
    console.log("Wrong parameters. Directory name expected.");
    process.exit(1);
}

const PATHNAME = process.argv[2].endsWith('/') ?
                 process.argv[2] : process.argv[2] + '/';

// List all filenames in dir received as argument
fs.readdir(PATHNAME, (err, files) => {
    if (err) throw err;
    files.forEach((filename) => {
        let newFilename = decodeURIComponent(filename);

        // Clean filename (CUSTOMIZE THIS)
        newFilename = newFilename
        // Remove accents/diacritics
        .normalize('NFD').replace(/[\u0300-\u036f]/g, "")
        // Make lowercase
        .toLowerCase()
        // Convert separators to low line
        .replace(/\s+/g, '_')
        // Remove any non-safe character
        .replace(/[^0-9a-zA-Z-._]/g, "");

        fs.rename(PATHNAME + filename, PATHNAME + newFilename, (err) => {
            if (err) throw err;
        });
    });
});

