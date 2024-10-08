import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config();

const owner = 'ilhamarief0';
const repo = 'ilkom-22-pararel-1';
const token = process.env.GITHUB_TOKEN;

const url = `https://api.github.com/repos/${owner}/${repo}/commits`;

const options = {
  headers: {
    'Authorization': `token ${token}`
  }
};

async function fetchCommits() {
  try {
    const response = await fetch(url, options);
    const data = await response.json();

    data.forEach(commit => {
      
      console.log(`Commit: ${commit.sha}`);
      console.log(`Author: ${commit.commit.author.name}`);
      console.log(`Message: ${commit.commit.message}`);
      console.log('--------------------');
    });
    // nim,name,account_git,commits,lines_added,lines_deleted
    // F1G122025,Muh. Ilham Arief Prabowo,ilhamariefprabowo,100,1200,0

    // UPDATE students SET commits = commit.count,lines_added = commit.lines_added.count , lines_deleted=commit.lines_deleted.count WHERE account_git= commit.commit.author.name


  } catch (error) {
    console.error('Error:', error);
  }
}

fetchCommits();