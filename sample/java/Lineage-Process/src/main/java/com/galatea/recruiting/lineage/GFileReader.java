package com.galatea.recruiting.lineage;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GFileReader {

	protected final Logger _logger = LoggerFactory.getLogger(getClass());

	protected final BufferedReader _reader;

	public GFileReader(final String fileName_) throws FileNotFoundException {
		_logger.info("Creating reader for {}", fileName_);
		_reader = new BufferedReader(new FileReader(new File(fileName_)));
	}

	public String readLine() throws IOException {
		return _reader.readLine();
	}
}
