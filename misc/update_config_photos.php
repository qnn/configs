<?php

include_once(__DIR__.'/spyc.php');

function list_all_files($dir) { 
   $result = array();
   $cdir = scandir($dir);
   foreach ($cdir as $key => $value) {
      if (!in_array($value,array(".",".."))) {
         if (is_dir($dir . DIRECTORY_SEPARATOR . $value)) {
            $result = array_merge($result, list_all_files($dir . DIRECTORY_SEPARATOR . $value));
         } else if ($value != 'index.html' && substr($value, 0, 4) != 'list') {
            $result[] = realpath( $dir . DIRECTORY_SEPARATOR . $value );
         }
      }
   }
   return $result;
}

$files = list_all_files(__DIR__.'/../configs');

foreach ($files as $file) {
    if (preg_match('#configs/(.*)/_config\.yml$#', $file)) {
        $config = file_get_contents($file);
        if (preg_match('/# 专卖店风采（大括号包围的块代表一个项目）\n([\S\s]+?\])/', $config, $matches)) {

            $oldcontent = $matches[0];
            $content = $matches[1];

            // remove last useless commas
            $content = preg_replace('/",([\n\s]+?})/', '"$1', $content);
            $content = preg_replace('/\},([\n\s]+?\])/', '}$1', $content);

            $array = Spyc::YAMLLoadString($content);

            $new = '';

            foreach ($array['photos'] as $item) {
                $location = '';
                if (isset($item['store'])) {
                    $location = <<<NEW

      **销售网点**：${item[store]}

NEW;
                }
                $new .= <<<NEW

  - thumb: ${item[thumb]}
    photo: ${item[photo]}
    content: |${location}
      **联系人**：${item[perso]}

      **电话**：${item[telep]}

      **地址**：${item[addre]}

NEW;
            }

            if ($new != '') {
                $new = <<<NEW

# 专卖店风采（ - 表示数组项目，content 用 markdown 格式）
photos:$new
NEW;
            }

            $newconfig = str_replace($oldcontent, $new, $config);
            file_put_contents($file, $newconfig);
        }
    }
}
