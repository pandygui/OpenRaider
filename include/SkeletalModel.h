/*!
 * \file include/SkeletalModel.h
 * \brief Moveable Mesh Geometry
 *
 * \author Mongoose
 * \author xythobuz
 */

#ifndef _SKELETALMODEL_H_
#define _SKELETALMODEL_H_

#include <vector>

#include "system/Shader.h"

class BoneTag {
  public:
    BoneTag(int m, glm::vec3 o, glm::vec3 r, char f) : mesh(m), off(o), rot(r), flag(f) { }
    void display(glm::mat4 MVP, ShaderTexture* shaderTexture = nullptr);

    glm::vec3 getOffset() { return off; }
    glm::vec3 getRotation() { return rot; }
    char getFlag() { return flag; }

  private:
    int mesh;
    glm::vec3 off, rot;
    char flag;
};

class BoneFrame {
  public:
    explicit BoneFrame(glm::vec3 p) : pos(p) { }
    ~BoneFrame();

    glm::vec3 getPosition() { return pos; }

    unsigned long size();
    BoneTag& get(unsigned long i);
    void add(BoneTag* t);

  private:
    glm::vec3 pos;
    std::vector<BoneTag*> tag;
};

class AnimationFrame {
  public:
    explicit AnimationFrame(char r) : rate(r) { }
    ~AnimationFrame();

    unsigned long size();
    BoneFrame& get(unsigned long i);
    void add(BoneFrame* f);

  private:
    char rate;
    std::vector<BoneFrame*> frame;
};

class SkeletalModel {
  public:
    explicit SkeletalModel(int i) : id(i) { }
    ~SkeletalModel();
    void display(glm::mat4 MVP, int aframe, int bframe, ShaderTexture* shaderTexture = nullptr);

    int getID() { return id; }

    unsigned long size();
    AnimationFrame& get(unsigned long i);
    void add(AnimationFrame* f);

  private:
    int id;
    std::vector<AnimationFrame*> animation;
};

#endif
