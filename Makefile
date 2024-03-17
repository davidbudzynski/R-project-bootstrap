.PHONY: clean
clean:
	find output/ -type d -exec rm -rf {}/\* \;
