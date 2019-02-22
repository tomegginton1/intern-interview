package com.galatea.recruiting.lineage;

import java.io.IOException;

public class GProcessDataset {

	public static final String INPUT_FILE = "tree.json";

	public static void main(String[] args_) throws IOException {
		GFileReader reader = new GFileReader(INPUT_FILE);
		System.out.println(reader.readLine());
		
		GJsonParsingExample.jsonParsingExample();
	}
}
