module.exports = function(eleventyConfig) {
  // Register currentYear filter to return the current year as a string
  eleventyConfig.addFilter("currentYear", () => {
    return new Date().getFullYear().toString();
  });

  eleventyConfig.addPassthroughCopy("css");

  return {
    dir: {
      input: ".",
      includes: "_includes",
      layouts: "_includes",
      output: "_site"
    }
  };
};